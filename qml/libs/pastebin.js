var UBUNTU_PASTEBIN_URL="http://paste.ubuntu.com/"

function post(message, name, on_success, on_failure)
{
    var args = new Array();

    args.push( "content=" + encodeURIComponent( message));
    args.push( "poster=" + encodeURIComponent( name));
    args.push( "syntax=text")

    var req = new XMLHttpRequest();
    req.open("post", UBUNTU_PASTEBIN_URL);
    req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    req.onreadystatechange = function() {
        if(req.readyState === XMLHttpRequest.DONE) {
            var response = req.responseText;
            if(response.toLowerCase().indexOf("bad") != 0) { // "Bad xxx: yyy"
                console.log("response is " + response)
                if(response.search("/plain/") === -1)  on_failure(response);
                var refpos=response.lastIndexOf("href")
                var urlslice = response.slice(refpos,response.length)
                var firstpos = urlslice.indexOf("/")
                var lastpos = urlslice.slice(firstpos+1,urlslice.length).indexOf("/")
                var result = urlslice.slice(firstpos+1, lastpos+firstpos+1)
                console.log("url is in here:" + result)
                on_success(UBUNTU_PASTEBIN_URL+ result+ "/");


            } else
                on_failure(response);
        }
    }

    req.send(args.join('&'));
}
