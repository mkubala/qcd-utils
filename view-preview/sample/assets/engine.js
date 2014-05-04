$(function () {
    var tipContent = $("#tip").find("#tipContent");

    function findClosestViewElemInfo(startingFromElement) {
        var descElem = $(startingFromElement).children(".desc:first");
        if (descElem.length == 0) {
            return $(startingFromElement).parents().find("> .desc").last();
        } else {
            return descElem;
        }
    }

    function extractInfo(descElem) {
        if (descElem.length == 0 || !descElem.hasClass("desc")) {
            return "---";
        } else {
            return descElem.html();
        }
    }

    $("div").click(function (e) {
        var targetJqElem = $(e.target),
            tipContentValue = "";
        $(".viewElement.focused").removeClass("focused");
        if (targetJqElem.hasClass("viewElement")) {
            var closestDescElem = findClosestViewElemInfo(targetJqElem);
            tipContentValue = extractInfo(closestDescElem);
            closestDescElem.parent().addClass("focused");
        }
        tipContent.html(tipContentValue);
    });
});