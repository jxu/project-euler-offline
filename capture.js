"use strict";

var renderDir = "render";


var arrayOfUrls = [];
var system = require('system');
var problemIDStart = system.args[1];
var problemIDEnd = system.args[2];

for (var problemID = problemIDStart; problemID <= problemIDEnd; problemID++) {
    arrayOfUrls.push("https://projecteuler.net/problem=" + problemID.toString());
}

/*
Render given urls
@param array of URLs to render
@param callbackPerUrl Function called after finishing each URL, including the last URL
@param callbackFinal Function called after finishing everything
*/
var RenderUrlsToFile = function(urls, callbackPerUrl, callbackFinal) {
    var webpage = require("webpage");
    var page = null;

    var getFilename = function(url) {
        return renderDir + '/' + url.split('=')[1] + ".pdf";
    };
    var next = function(status, url, file) {
        page.close();
        callbackPerUrl(status, url, file);
        return retrieve();
    };
    var retrieve = function() {
        if (urls.length > 0) {
            var url = urls.shift();
            page = webpage.create();
            page.viewportSize = {
                width: 1000,
                height: 1000
            };

            page.paperSize = {
                format: 'Letter',
                margin: '50px'
            };

            page.settings.userAgent = "Project Euler Offline bot";

            return page.open(url, function(status) {
                var file = getFilename(url);
                if (status === "success") {
                    return window.setTimeout((function() {
                        page.render(file);
                        return next(status, url, file);
                    }), 2000);
                } else {
                    return next(status, url, file);
                }
            });
        } else {
            return callbackFinal();
        }
    };
    return retrieve();
};



RenderUrlsToFile(arrayOfUrls, (function(status, url, file) {
    if (status !== "success") {
        return console.log("Unable to render '" + url + "'");
    } else {
        return console.log("Rendered '" + url + "' at '" + file + "'");
    }
}), function() {
    return phantom.exit();
});

