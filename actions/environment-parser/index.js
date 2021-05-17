const core = require('@actions/core');
const github = require('@actions/github');
const yaml = require('js-yaml');
const _ = require('lodash');

try {
    let value = core.getInput('value');
    value = yaml.load(value, 'utf8');

    let branch = github.context.ref.split('/');
    branch = branch[branch.length - 1];

    let output = {};

    if (!!value.default) {
        output = _.merge(output, value.default);
    }

    for (const key of Object.keys(value)) {
        const regex = key.replace('*', '.*')
        if (!(new RegExp(regex).test(branch))) {
            continue;
        }

        output = _.merge(output, value[key])
    }

    console.log('Generated output', output);
    core.setOutput('variables', output);
} catch (error) {
    core.setFailed(error);
}