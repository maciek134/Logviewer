const LAP_PREFIX = 'lomiri-app-launch--application-click--';
const LAP_LEGACY_PREFIX = 'lomiri-app-launch--application-legacy--';
const LAP_SUFFIX = '--.service';

/**
 * Parses the systemd service name to something nicer
 * @param {string} name service name we get from systemd-journald
 * @returns {object} parsed service
 */
function parseServiceName(name) {
    const isClick = name.startsWith(LAP_PREFIX);
    const isDeb = name.startsWith(LAP_LEGACY_PREFIX);

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
            fullName: `${namespace}_${clickName}_${version}`,
        };
    } else if (isDeb) {
        const debName = name.slice(LAP_LEGACY_PREFIX.length, -LAP_SUFFIX.length);
        return {
            type: 'deb',
            namespace: '',
            name: debName,
            version: '',
            fullName: debName,
        }
    }

    return {
        type: 'service',
        name: name.replace('.service', ''),
    };
}

/**
 * Converts the parsed object to a user-facing string
 * @param {object} parsed result of the `parseServiceName` function
 * @param {array} iconAndName result of LomiriAppLaunch.iconAndName
 * @returns {string} formatted service name
 */
function parsedNameToString(parsed, iconAndName) {
    if (parsed.type === 'service') {
        return parsed.name;
    } else if (parsed.type === 'deb') {
        return iconAndName[1] || parsed.name;
    }

    return `${iconAndName[1] || parsed.name} v${parsed.version}`;
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

/**
 * Checks whether the current unit name comes from push helper
 * @param {string} name unit name
 * @returns {bool} whether the unit is from a push helper
 */
function isPush(name) {
    return name.startsWith('lomiri-app-launch--push-helper');
}
