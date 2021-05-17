const core = require('@actions/core');
const github = require('@actions/github');
const yaml = require('js-yaml');

try {
    let value = core.getInput('value');
    value = yaml.load(value, 'utf8');
    console.log(value);
} catch (error) {
    core.setFailed(error);
}