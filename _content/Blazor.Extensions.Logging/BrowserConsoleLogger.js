var LogLevel;
(function (LogLevel) {
    LogLevel["Trace"] = "trace";
    LogLevel["Debug"] = "debug";
    LogLevel["Information"] = "information";
    LogLevel["Warning"] = "warning";
    LogLevel["Error"] = "error";
    LogLevel["Critical"] = "critical";
    LogLevel["None"] = "none";
})(LogLevel || (LogLevel = {}));
var LogObjectType;
(function (LogObjectType) {
    LogObjectType["String"] = "string";
    LogObjectType["Object"] = "object";
    LogObjectType["Table"] = "table";
})(LogObjectType || (LogObjectType = {}));
export const log = (logObjectValue) => {
    let logObject;
    try {
        logObject = JSON.parse(logObjectValue);
    }
    catch (error) {
        throw new Error(`Error parsing JSON payload passed to BrowserConsoleLogger: ${error}`);
    }
    let logMethod = console.log;
    if (logObject.type === LogObjectType.Table) {
        logMethod = console.table;
    }
    else {
        switch (logObject.logLevel) {
            case LogLevel.Trace:
                logMethod = console.trace;
                break;
            case LogLevel.Debug:
                logMethod = console.debug;
                break;
            case LogLevel.Warning:
                logMethod = console.warn;
                break;
            case LogLevel.Error:
            case LogLevel.Critical:
                logMethod = console.error;
                break;
        }
    }
    if (logObject.type == LogObjectType.Table) {
        logMethod(logObject.payload);
    }
    else {
        logMethod(`[${logObject.category}]`, logObject.payload);
    }
    if (logObject.exception) {
        logMethod(`[${logObject.category}] Exception:`, logObject.exception);
    }
};
