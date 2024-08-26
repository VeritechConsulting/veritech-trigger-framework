# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.3.0 - 2024-08-26
### Added
- New method `allowRecursion()` to simplify the setup of triggers requiring recursion.

### Changed
- Updated PMD rulesets to comply with the latest PMD release.
- Updated Salesforce API versions.
- Updated package versions in `package.json`.
- Updated README.

## 1.2.0 - 2024-02-20
### Added
- Included `examples` as a packaged directory in `sfdx-project.json` to make it deployable.

### Fixed
- Addressed a bug in the test method `TriggerUtilTest.getRecordTypeId_existingDeveloperName_idReturned()`.

### Changed
- Updated `BaseTriggerHandler` to use the new Null Coalescing Operator.
- Updated `TriggerUtil` to use the sharing model `inherited`.
- Updated test classes to use the sharing model `without sharing`.
- Updated Salesforce API versions.
- Updated package versions in `package.json`.
- Updated README.

### Removed
- Removed references to the packages `lint-staged` and `husky`.

## 1.1.0 - 2023-11-27
### Added
- New methods to determine if a specific trigger is enabled and new test methods to cover them.

### Fixed
- Moved recording of trigger execution to the beginning to address a recursion bug.

### Changed
- Updated Salesforce  API versions.
- Moved examples to a top-level folder.
- Updated README.

## 1.0.0 - 2023-09-15
### Added
- Created a new Trigger Framework for Salesforce.