/*global document: false, $: false, window: false, document: false, unescape: false*/

var FeedbackButtonBoolean;

function getURLParam(ParamName) {
    "use strict";
    var query = window.location.search.substring(1),
        vars = query.split("&"),
        i,
        pair;
    for (i = 0; i < vars.length; i += 1) {
        pair = vars[i].split("=");
        if (pair[0] === ParamName) {
            return unescape(pair[1]);
        }
    }
}

function getURLParamOrEmpty(ParamName) {
    "use strict";
    var urlParam = getURLParam(ParamName);
    if (urlParam === undefined) {
        return '';
    }
    return urlParam;
}
function getCookieParam(c_name) {
    "use strict";
    var cookies = document.cookie.split("; "),
        i,
        cookie;
    for (i = 0; i < cookies.length; i += 1) {
        cookie = cookies[i].split("=");
        if (cookie[0] === c_name) {
            return cookie[1];
        }
    }
    return undefined;
}
function FeedbackButtonClicked() {
    "use strict";
    var thisUrl = "feedback_bvl_popup.php?test_name=" + getURLParamOrEmpty('test_name') +
        '&candID=' + getURLParamOrEmpty('candID') +
        '&sessionID=' + getURLParamOrEmpty('sessionID') +
        '&commentID=' + getURLParamOrEmpty('commentID');
    document.cookie = "FeedbackButtonBoolean = true";
    window.open(thisUrl, "MyWindow", "width=800, height=600, resizable=yes, scrollbars=yes, status=no, toolbar=no, location=no, menubar=no");
}

function feedback_bvl_popup(features) {
    "use strict";
    if (getCookieParam('FeedbackButtonBoolean')) {
        var myUrl = "feedback_bvl_popup.php?test_name=" + getURLParamOrEmpty('test_name') +
            '&candID=' + getURLParamOrEmpty('candID') +
            '&sessionID=' + getURLParamOrEmpty('sessionID') +
            '&commentID=' + getURLParamOrEmpty('commentID');
        window.open(myUrl, "MyWindow", "width=800, height=600, resizable=yes, scrollbars=yes, status=no, toolbar=no, location=no, menubar=no");
    }
}

function open_help_section() {
    "use strict";
    var helpurl = "context_help_popup.php?test_name=" + getURLParamOrEmpty('test_name');
    window.open(helpurl);
}
