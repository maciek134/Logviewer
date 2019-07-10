var UBUNTU_PASTEBIN_URL="http://paste.ubuntu.com/"

function post(message, name, on_success, on_failure) {
    var args = new Array();

    message = message.replace(/\n\n/g, "\n"); // remove blank lines
    var lines = message.split('\n');
    if (lines.length > 150) {
        message = "";
        for (var i = lines.length - 150; i < lines.length; i++) {
            message += lines[i] + "\n";
        }
    }

    args.push("content=" + encodeURIComponent(message));
    args.push("poster=" + encodeURIComponent(name));
    args.push("syntax=text");

    var req = new XMLHttpRequest();
    req.open("post", UBUNTU_PASTEBIN_URL);
    req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var response = req.responseText;
            if(response.toLowerCase().indexOf("bad") != 0) { // "Bad xxx: yyy"
                console.log("response is " + response)
                if(response.search("/plain/") === -1) on_failure(response);
                var result = response.slice(
                    response.lastIndexOf("href=\"") + 7,
                    response.lastIndexOf("/plain/")
                );
                console.log("url is in here:" + result)
                on_success(UBUNTU_PASTEBIN_URL + result+ "/");
            } else {
                on_failure(response);
            }
        }
    }

    req.send(args.join('&'));
}
