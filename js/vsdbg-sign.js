declare module vsda {
    export class signer {
        sign(arg: string): string;
    }
    export class validator {
        createNewMessage(arg: string): string;
        validate(arg: string): 'ok' | 'error';
    }
}
function getExecutableDirectory(executable) {
    try {
        // Use 'which' on Unix-like systems, 'where' on Windows
        const command = process.platform === "win32" ? "where" : "which";
        const fullPath = execSync(`${command} ${executable}`, { encoding: "utf-8" })
            .split("\n")[0]  // Take the first result (in case of multiple)
            .trim();

        return path.dirname(fullPath);
    } catch (error) {
        console.error(`Executable "${executable}" not found in PATH.`);
        return null;
    }
}

const vsda_location = getExecutableDirectory('code') + '\\..\\resources\\app\\node_modules.asar.unpacked\\vsda\\build\\Release\\vsda.node';
console.log("vsda sourced at:", vsda_location);
const a: typeof vsda = require(vsda_location);
const signer: vsda.signer = new a.signer();
process.argv.forEach((value, index, array) => {
    if (index >= 2) {
        const r = signer.sign(value);
        console.log(r);
    }
});
