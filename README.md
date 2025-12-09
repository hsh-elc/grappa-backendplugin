# Proforma #

This Java library provides the base class of all grader-specific backend plugins of the grappa-webservice.

Find more documentation here: [`https://github.com/hsh-elc/grappa-webservice/blob/master/documents/concept/documentation.md#5-modules`](https://github.com/hsh-elc/grappa-webservice/blob/master/documents/concept/documentation.md#5-modules)

## License ##

2020 ZLB-ELC Hochschule Hannover <elc@hs-hannover.de>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not,
see <http://www.gnu.org/licenses/>.


## Installation ##

You can download the current release and install it in your local maven repository with the command line tool:

```bash
mvnInstallGrappaBackendpluginDependenciesFromGithub.sh
```

Help for the tool is available:

```bash
mvnInstallGrappaBackendpluginDependenciesFromGithub.sh -h
```

## Gradle Build

Before build, download and install dependencies for ProFormA java libraries from github:

```bash
./mvnInstallProformaDependenciesFromGithub.sh
```

Then you can build the `jar`-file with:

```
mvn -DskipTests clean package
```

The jar file can be found in `target`. It contains a pom.xml with all dependencies.

