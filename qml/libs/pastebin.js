var UBUNTU_PASTEBIN_URL="https://dpaste.com/api/"

function post(message, on_success, on_failure) {
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
    args.push("syntax=text");

    var req = new XMLHttpRequest();
    req.open("post", UBUNTU_PASTEBIN_URL);
    req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var response = req.responseText;
            if(response.toLowerCase().indexOf("bad") != 0) { // "Bad xxx: yyy"
                console.log("response is " + response)
                var result = response.slice(
                    response.lastIndexOf("href=\"") + 7,
                    response.lastIndexOf("/plain/")
                );
                console.log("url is in here:" + " https:"  + result)
                on_success("https:" +result);
            } else {
                on_failure(response);
            }
        }
    }
    

    req.send(args.join('&'));
}
