const core = require('@actions/core');
const github = require('@actions/github');
const yaml = require('js-yaml');

try {
    let value = core.getInput('value');
    value = yaml.load(value, 'utf8');

    let branch = github.context.ref.split('/');
    branch = branch[branch.length - 1];

    for (const key of Object.keys(value)) {
        const regex = key.replace('*', '.*')
        if (!(new RegExp(regex).test(branch))) {
            continue;
        }

        core.setOutput('variables', JSON.stringify(value[key]))
        break;
    }

} catch (error) {
    core.setFailed(error);
}