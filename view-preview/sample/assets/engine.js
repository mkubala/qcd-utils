$(function () {
    var tipContent = $("#tip").find("#tipContent");

    function extractInfo(elem) {
        var descElem = $(elem).find(".desc:first");
        if (descElem.length == 0) {
            descElem = $(elem).parents().find("> .desc");
            if (descElem.length == 0) {
                return "---";
            } else {
                return descElem.last().text();
            }
        } else {
            return descElem.text();
        }
    }

    $("div").click(function (e) {
        var targetJqElem = $(e.target),
            tipContentValue = "";
        if (targetJqElem.hasClass("viewElement")) {
            tipContentValue = extractInfo(e.target);
        }
        tipContent.html(tipContentValue);
    });
});