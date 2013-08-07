module.exports = function (datevalue) {
    var chunks = {
        'year': 31536000,
        'month': 2592000,
        'week': 604800,
        'day': 86400,
        'hour': 3600,
        'minute': 60,
        'second': 1
    };

    var year = parseInt(datevalue.substr(0, 4), 10);
    var month = parseInt(datevalue.substr(5, 2), 10) - 1;
    var day = parseInt(datevalue.substr(8, 2), 10);
    var hour = parseInt(datevalue.substr(11, 2), 10);
    var minute = parseInt(datevalue.substr(14, 2), 10);

    var older_date = new Date(year, month, day, hour, minute, 0).getTime() / 1000;
    var newer_date = new Date().getTime() / 1000;

    var returnvalue = ""
    for(key in chunks) {
        var seconds = chunks[key]
        var count = Math.floor((newer_date - older_date) / seconds)
        if (count > 0) {
            switch (key) {
                case 'year':
                    returnvalue = count + " " + (count == 1 ? "year" : "years") + " ago";
                    break;
                case 'month':
                    returnvalue = count + " " + (count == 1 ? "month" : "months") + " ago";
                    break;
                case 'week':
                    returnvalue = count + " " + (count == 1 ? "week" : "weeks") + " ago";
                    break;
                case 'day':
                    returnvalue = count + " " + (count == 1 ? "day" : "days") + " ago";
                    break;
                case 'hour':
                    returnvalue = count + " " + (count == 1 ? "hour" : "hours") + " ago";
                    break;
                case 'minute':
                    returnvalue = count + " " + (count == 1 ? "minute" : "minutes") + " ago";
                    break;
                case 'second':
                    returnvalue = count + " " + (count == 1 ? "second" : "seconds") + " ago";
                    break;
            }

            if (returnvalue != "") {
                return returnvalue;
            }
        }
    }

    return "";
}
