---
title: "A fable of Web MIDI"
layout: post
category: .Net
tags:
- How-To
- .Net
- F#
- Fable
- React
- Elmish
- MIDI
disqus_category: 1836768
---

This post is part of the [F# Advent Calendar 2017](https://sergeytihon.com/2017/10/22/f-advent-calendar-in-english-2017/) series.

In this post I describe how to create useful [Fable] bindings for [Web MIDI] and use them in a Fable-Elmish-React application. 

## TL;DR

It's quite easy to write Javascript bindings for [Fable]
The resulting output can be found here:

- [Sample app](https://github.com/magicmonty/fable-webmidi-sample)
- [Volca FM Patch editor](https://github.com/magicmonty/volca-fm-editor)
- Fable bindings for Web MIDI
  - [Project](https://github.com/magicmonty/fable-import-webmidi)
  - [NuGet Package](https://www.nuget.org/packages/Fable.Import.WebMIDI/)

## Prerequisites

Before we start we need to get a new Fable application up and running.

Install the Fable Template

```
$ dotnet new -i Fable.Template
```

Create a new Project and change into project directory

```sh
$ dotnet new fable -n volca
$ cd volca 
```

Since we want to create a Fable Elmish app add the following entries to the `paket.dependencies`:

```
nuget Fable.Elmish.Browser
nuget Fable.Elmish.Debugger
nuget Fable.Elmish.React
nuget Fable.Elmish.HMR
```

then add the following entries to `src/paket.references`:

```
Fable.Elmish.Browser
Fable.Elmish.Debugger
Fable.Elmish.React
Fable.Elmish.HMR
```

now install all yarn and .NET dependencies

```sh
$ yarn add react react-dom
$ cd src
$ mono ../.paket/paket.exe install
$ dotnet restore
```

Update the file `public/index.html`, so that it looks like this:

```html
<!doctype html>
<html>

<head>
  <title>MIDI test</title>
  <meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="shortcut icon" href="fable.ico" />
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
</head>

<body class="app-container">
  <div id="midi-app" class="midi-app" />
  <script src="bundle.js"></script>
</body>

</html>
```

You can now open the project folder in Visual Studio Code (with the Ionide plugins installed) and run the following in the integrated terminal:

```sh
$ cd src
$ dotnet fable yarn-start
```

Now lets code.

What we want is an app which can handle MIDI Inputs and MIDI outputs and can send and receive MIDI messages via [Web MIDI].

## Building the UI

First we need a model. We want a list of inputs, a list of outputs, the possibility to select either of them
and the reference to the [MIDIAccess] object, which we
fill in later. 

*Please note, Web MIDI currently works only in Chrome!*

```fsharp
module MidiTest

type MIDIAccess = obj

type Alert =
  | Info of string
  | Success of string
  | Warning of string
  | Error of string

type Model =  { MIDIOutputs: (string*string) list
                SelectedMIDIOutput: string option
                MIDIAccess: MIDIAccess option
                IsMIDIEnabled: bool
                Messages: Alert list }
```

For now we need some basic messages, which handle the UI state:

```fsharp
type Msg = 
  | MIDIConnected of IMIDIAccess     // MIDI successfully connected
  | MIDIStateChange                  // MIDI ports have changed
  | MIDIError of exn                 // Error connecting MIDI
  | Message of Alert                 // A message
  | OutputSelected of string
  | SendNote                        // Send a MIDI note
```

Now we can initialize our model:

```fsharp
open Elmish
open Fable.Import
open Fable.Core.JsInterop

let init () : Model*Cmd<Msg> =
    { MIDIOutputs = []
      SelectedMIDIOutput = None
      MIDIAccess = None
      IsMIDIEnabled = false
      Messages = [] }, Cmd.none
```

The `update` function updates the model based on the received message:

```fsharp
let update (msg:Msg) (model:Model) : Model*Cmd<Msg> =    
    let success = Success >> Message >> Cmd.ofMsg
    let info = Info >> Message >> Cmd.ofMsg
    let error = Error >> Message >> Cmd.ofMsg
    
    match msg with
    | MIDIConnected midiAccess -> 
        { model with MIDIAccess = Some midiAccess
                     IsMIDIEnabled = true }, Cmd.batch [ success "MIDI connected"
                                                         Cmd.ofMsg MIDIStateChange ]
    | MIDIStateChange -> model, info "State changed"
    | MIDIError ex ->
        { model with MIDIAccess = None
                     MIDIOutputs = []
                     IsMIDIEnabled = false
                     SelectedMIDIOutput = None  }, error ex.Message
    | Message alert -> { model with Messages = alert :: model.Messages |> List.truncate 5 }, Cmd.none
    | OutputSelected id ->
        { model with SelectedMIDIOutput = match id with 
                                          | "" -> None 
                                          | id -> Some id }, Cmd.none
    | SendNote -> model, info "TBD: Note on"
```

Last but not least we need a view:

```fsharp
open Fable.Helpers.React
open Fable.Helpers.React.Props

let view model dispatch =
    div [ ClassName "container" ] [
        div [ ClassName "row" ] [
            div [ ClassName "col" ] [
                div [ ClassName "card" ] [
                    div [ ClassName "card-header" ] [ strong [] [ str "MIDI Test"] ]
                    div [ ClassName "card-body" ] [
                        div [ ClassName "form-group" ] [
                            label [ ClassName "col-form-label" ] [ str "Outputs" ]
                            select [ ClassName "form-control" 
                                     Value (model.SelectedMIDIOutput |> Option.defaultValue "") 
                                     OnChange (fun (ev:React.FormEvent) -> dispatch (OutputSelected (!! ev.target?value))) ] [
                                         for key, name in model.MIDIOutputs do
                                            yield option [ Key key ] [ str name ]
                                     ]
                        ]
                    ]
                    div [ ClassName "card-footer" ] [
                        button [ ClassName "btn btn-primary" 
                                    OnClick (fun _ -> dispatch SendNote) ] [ str "Send Note" ]
                    ]
                ]
            ]

            div [ ClassName "col" ] [
                div [ ClassName "card" ] [ 
                    div [ ClassName "card-header" ] [ strong [] [ str "MIDI Messages"] ]
                    div [ ClassName "card-body" ] [ 
                        for msg in model.Messages do
                            match msg with
                            | Info msg -> yield div [ ClassName "alert alert-info" ] [ str msg ]
                            | Success msg -> yield div [ ClassName "alert alert-success" ] [ str msg ]
                            | Warning msg -> yield div [ ClassName "alert alert-warning" ] [ str msg ]
                            | Error msg -> yield div [ ClassName "alert alert-danger" ] [ str msg ]
                    ]
                ]
            ]
        ]
    ]
```

To make everything work, we need to create our React-Elmish application:

```fsharp
open Elmish.React

Program.mkProgram init update view
|> Program.withReact "midi-app"
|> Program.run
```

Now, that we have a basic UI running, we come to the interesting part.

## Creating Fable bindings for Web MIDI

If we look at the [Web MIDI] specification we see, that we need to define
a bunch of interfaces. This is a quite straightforward copy of the types
defined in the [Web MIDI] specification:

```fsharp
module WebMIDI

open Fable.Core
open Fable.Import

type MIDIOption =
    | Sysex of bool

[<StringEnum>]
type MIDIPortType =
    | Input
    | Output

[<StringEnum>]
type MIDIPortDeviceState =
    | Connected
    | Disconnected

[<StringEnum>]
type MIDIPortConnectionState =
    | Open
    | Closed
    | Pending

type IMIDIPort =
    inherit Browser.EventTarget
    abstract member id: string with get
    abstract member manufacturer: string option with get
    abstract member name: string option with get
    [<Emit("$0.type")>]
    abstract member Type: MIDIPortType with get
    abstract member version: string option with get
    abstract member state: MIDIPortDeviceState with get
    abstract member connection: MIDIPortConnectionState with get
    abstract member onstatechange: (IMIDIConnectionEvent -> unit) with set
    [<Emit("$0.open")>]
    abstract member Open : unit -> JS.Promise<IMIDIPort>
    abstract member close : unit -> JS.Promise<IMIDIPort>

and IMIDIConnectionEvent =
    inherit Browser.EventType
    abstract member port : IMIDIPort with get

type IMIDIOutput =
    inherit IMIDIPort
    abstract member send : byte array -> unit
    [<Emit("$0.send($2, $1)")>]
    abstract member SendAt : float -> byte array -> unit
    abstract member clear : unit -> unit

type IMIDIOutputMap = JS.Map<string, IMIDIOutput>

type IMIDIMessageEvent =
    inherit Browser.EventType
    abstract member receivedTime: double
    abstract member data: byte array
    
type IMIDIInput = 
    inherit IMIDIPort
    abstract member onmidimessage : (IMIDIMessageEvent -> unit) with set

type IMIDIInputMap = JS.Map<string, IMIDIInput>

type IMIDIAccess = 
    inherit Browser.EventTarget
    abstract member inputs : IMIDIInputMap with get
    abstract member outputs : IMIDIOutputMap with get
    abstract member onstatechange : (IMIDIConnectionEvent -> unit) with set
    abstract member sysexEnabled: bool with get

type MIDISuccessCallback = IMIDIAccess * MIDIOption -> unit
```

However, there are some specialities:

- The `MIDIOption` is not modelled as an object but as a discriminated union. A list of `MIDIOption` elements will be later converted via `keyValueList` into a JS object.
- `MIDIPortType`, `MIDIPortDeviceState` and `MIDIPortConnectionState` are in JavaScript just strings but with some predefined values. For a better type safety they are here union types with the `[<StringEnum>]` attribute, which makes fable to compile these values to strings in JS.
- Nullable DOMStrings (DOMString? in the specification) map to optional values
- Promises map to `Fable.Import.JS.Promise<'a>`
- MapLike elements to `Fable.Import.JS.Map<'key,'value>`
- `UInt8Array`s will be represented here by `byte array`
- The hardest part was to figure out, how to get the event handlers working correctly. I found, the easiest way was to make a property, where we can set a function as handler
- Some members (like `IMIDIPort.type` or `IMIDIPort.open`) I had to write differently, as they are keywords in F#. To the rescue comes here the `[<Emit()>]` attribute, which is used hint fable how to output the JavaScript for this calls.

Now we need a way to get access to the MIDI functionality of the browser. This is what is `navigator.requestMIDIAccess()` is for. If we want to send SysEx messages then we have to call `navigator.requestMIDIAccess({ sysex: true }).
This is the matching fable code:

```fsharp
module internal Intern =

    [<Emit("navigator.requestMIDIAccess($0)")>]
    let requestAccess (options : obj) : JS.Promise<IMIDIAccess> = jsNative

open Fable.PowerPack

[<RequireQualifiedAccess>]
module MIDI =
    let requestAccess (options : MIDIOption list) : JS.Promise<IMIDIAccess> =
        Intern.requestAccess (JsInterop.keyValueList CaseRules.LowerFirst options)
```

The real request is hidden in an internal module and the MIDI module is decorated with a `[<RequireQualifiedAccess>]` attribute, so we can force the user to call this via `MIDI.requestAccess`. Also the user has to give a list of `MIDIOption` as parameter, which is then converted via `JsInterop.keyValueList` to a JSON object.

So how ist this API used in our application?

The first we do is to change our `init ()` function to return a new command from the promise, which is returned from `MIDI.requestAccess`:

```fsharp
let init () : Model*Cmd<Msg> =
    { MIDIOutputs = []
      SelectedMIDIOutput = None
      MIDIAccess = None
      IsMIDIEnabled = false
      Messages = [] }, Cmd.ofPromise MIDI.requestAccess [ Sysex true ] MIDIConnected MIDIError
```

This calls `MIDI.requestAccess` on the start of the application (a.k.a. browser reload) and sends a `MIDIConnected` message on success or a `MIDIError` message on error. In the update function this message is then used to set
the `IsMIDIEnabled` and the `MIDIAccess` settings in the model accordingly. On Success also a `MIDIStateChange` message is send, as we now want to populate our output box with MIDI outputs. I also added helper methods for the Messages, which go to the list on the right side:

```fsharp
let update (msg:Msg) (model:Model) : Model*Cmd<Msg> =    
    let success = Success >> Message >> Cmd.ofMsg
    let info = Info >> Message >> Cmd.ofMsg
    let error = Error >> Message >> Cmd.ofMsg
    
    match msg with  
    ...
    | MIDIStateChange ->
        let outputs = 
            match model.MIDIAccess with
            | Some midiAccess ->
                midiAccess.outputs 
                |> JSMap.toList 
                |> List.map (fun (key, o) -> key, (o.name |> Option.defaultValue "?")) 
            | None -> []
        
        let selectedOutput = 
            match outputs with
            | (key, _)::_ -> Some key
            | _ -> None

        { model with MIDIOutputs = outputs
                     SelectedMIDIOutput = selectedOutput }, info "State changed"
    | ...
```

For the easier handling of JS.Maps I wrote a litte helper function `JSMap.toList` which converts a `JS.Map<'key, 'value>` into a list of tuples:

```fsharp
[<RequireQualifiedAccess>]
module JSMap =
    let toList (m: JS.Map<'key, 'value>): ('key * 'value) list =
        let mutable result = []
        m.forEach (fun value key _ -> result <- (key, value)::result) 
        result
```

Until now we get only at the start of the app a list of MIDI outputs. What we want, is a dynamic reload of the outputs list, when a new output is added or removed. So enter subscriptions:

```fsharp
let update (msg:Msg) (model:Model) : Model*Cmd<Msg> =    
    ...

    match msg with
    | MIDIConnected midiAccess -> 
        let stateChangeSub dispatch =
            midiAccess.onstatechange <- (fun (ev:IMIDIConnectionEvent) -> (dispatch MIDIStateChange))

        { model with MIDIAccess = Some midiAccess
                     IsMIDIEnabled = true }, Cmd.batch [ success "MIDI connected"
                                                         Cmd.ofSub stateChangeSub
                                                         Cmd.ofMsg MIDIStateChange ]
```

If MIDI was successfully initialized, we add an event handler on the `MIDIAccess.onstatechange` event, which publishes a new `MIDIStateChange` event to our app. So everytime the state change event is fired, the list of outputs will be updated.
The results looks something like this:

![Screen grab MIDIStateChange]({% asset_path screen.gif %})

The last puzzle piece is now sending a note event to the MIDI device:

```fsharp
let sendNote (midiAccess: IMIDIAccess) portId =
    let output = midiAccess.outputs.get(portId);
    
    // note on, middle C, full velocity
    let noteOnMessage = [| 0x90uy; 60uy; 0x7fuy |]
    
    // note off, middle C, release velocity = 64 
    let noteOffMessage = [| 0x80uy; 60uy; 0x40uy |]
    
    //omitting the timestamp means send immediately.
    output.send noteOnMessage   
    
    // timestamp = now + 1000ms.
    noteOffMessage |> output.SendAt (Browser.window.performance.now() + 1000.0)
```

At last we call it in the update function:

```fsharp
let update (msg:Msg) (model:Model) : Model*Cmd<Msg> =    
    ...

    match msg with
    ...
    | SendNote -> 
        match model.MIDIAccess, model.SelectedMIDIOutput with
        | Some midi, Some out -> 
            model, Cmd.ofFunc (sendNote midi) 
                              out 
                              (fun _ -> Message (Success "sent")) 
                              (fun ex -> Message (Error ex.Message))
        | Some _, None -> model, error "No Output"
        | _, _ -> model, error "No MIDI connection"
```

with the following result:

![Screen grab "Send Note"]({% asset_path screen2.gif %})

## Conclusion

It is not that hard to write bindings for fable, which are nice to use from the F# side.
The complete source code for this post can be found at http://github.com/magicmonty/fable-webmidi-sample.

A more complex version, which is a Patch-Editor for the [Korg Volca FM](http://www.korg.com/products/dj/volca_fm/) can be found [here](http://magicmonty.github.com/volca-fm-editor/).

I also released a NuGet package with the [Web MIDI] bindings for [Fable]. The source code can be found at [https://github.com/magicmonty/fable-import-webmidi](https://github.com/magicmonty/fable-import-webmidi) and the package at [https://nuget.org/packages/Fable.Import.WebMIDI](https://nuget.org/packages/Fable.Import.WebMIDI)

[Fable]: http://fable.io
[Web MIDI]: https://www.w3.org/TR/webmidi/
[MIDIAccess]: https://www.w3.org/TR/webmidi/#midiaccess-interface