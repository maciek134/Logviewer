const PASTEBIN_URL="https://dpaste.com/api/"
const PASTE_CHAR_LIMIT = 250000;
const PASTE_TITLE_LIMIT = 100;

function post(message, unit, on_success, on_failure) {
    const args = [];

    args.push("content=" + encodeURIComponent(
        message
            .replace(/\n\n/g, "\n")     // remove blank lines
            .slice(-PASTE_CHAR_LIMIT)   // make sure it fits
        ),
    );
    args.push("syntax=text");
    args.push(`title=${encodeURIComponent(unit.slice(-PASTE_TITLE_LIMIT))}`)

    const req = new XMLHttpRequest();
    req.open("post", PASTEBIN_URL);
    req.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    req.setRequestHeader("User-Agent", `LogViewer/${appVersion} Ubuntu Touch`);

    req.onreadystatechange = () => {
        if (req.readyState !== XMLHttpRequest.DONE) {
            return;
        }

        const response = req.responseText;
        if (req.status !== 201) {
            return on_failure(response);
        }

        const result = response.slice(
            response.lastIndexOf("href=\"") + 7,
            response.lastIndexOf("/plain/")
        );
        on_success(`https:${result}`);
    }

    req.send(args.join("&"));
}
