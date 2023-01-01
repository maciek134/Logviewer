const LAP_PREFIX = 'lomiri-app-launch--application-click--';
const LAP_SUFFIX = '--.service';

/**
 * Parses the systemd service name to something nicer
 * @param {string} name service name we get from systemd-journald
 * @returns {object} parsed service
 */
function parseServiceName(name) {
    const isClick = name.startsWith(LAP_PREFIX);

    // TODO: maybe use the click Python package to get details
    //       like nice name, icon, etc.
    if (isClick) {
        const [namespace, clickName, version] = name
            .slice(LAP_PREFIX.length, -LAP_SUFFIX.length)
            .split('_');
        return {
            type: 'click',
            namespace,
            name: clickName,
            version,
        };
    }

    return {
        type: 'service',
        name: name.replace('.service', ''),
    };
}

/**
 * Converts the parsed object to a user-facing string
 * @param {object} parsed result of the `parseServiceName` function
 * @returns {string} formatted service name
 */
function parsedNameToString(parsed) {
    if (parsed.type === 'service') {
        return parsed.name;
    }

    return `v${parsed.version} ${parsed.name}`;
}

/**
 * Converts the log line to a user-facing string
 * @param {object} modelRow a ListView model-like object
 * @returns {string} formatted message
 */
function logLineToString(modelRow) {
    const { datetime, message } = modelRow;
    return `[${datetime.toLocaleString(Qt.locale(), Locale.ShortFormat)}] ${message}`;
}
