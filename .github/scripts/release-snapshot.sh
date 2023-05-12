#!/usr/bin/env bash
set -ex

find . -name "*.jar"

TAG="snapshot"
DATE_TIME_UTC=$(date -u +"%F at %T (UTC)")

gh release delete "${TAG}" -y || true

git tag --force "${TAG}"

git push --force origin "${TAG}"

mkdir "github_release"

cp "build/publications/maven/module.json" "github_release/plantuml-SNAPSHOT-module.json"
cp "build/publications/maven/pom-default.xml" "github_release/plantuml-SNAPSHOT.pom"
cp "build/libs/plantuml-${RELEASE_VERSION}.jar" "github_release/plantuml-SNAPSHOT.jar"
cp "build/libs/plantuml-${RELEASE_VERSION}-javadoc.jar" "github_release/plantuml-SNAPSHOT-javadoc.jar"
cp "build/libs/plantuml-${RELEASE_VERSION}-sources.jar" "github_release/plantuml-SNAPSHOT-sources.jar"
cp "build/libs/plantuml-pdf-${RELEASE_VERSION}.jar" "github_release/plantuml-pdf-SNAPSHOT.jar"
cp "plantuml-mit/build/libs/plantuml-mit-${RELEASE_VERSION}.jar" "github_release/plantuml-mit-SNAPSHOT.jar"
cp "plantuml-mit/build/libs/plantuml-mit-${RELEASE_VERSION}-sources.jar" "github_release/plantuml-mit-SNAPSHOT-sources.jar"

if [[ -e "build/publications/maven/module.json.asc" ]]; then
  # signatures are optional so that forked repos can release snapshots without needing a gpg signing key
  cp "build/publications/maven/module.json.asc" "github_release/plantuml-SNAPSHOT-module.json.asc"
  cp "build/publications/maven/pom-default.xml.asc" "github_release/plantuml-SNAPSHOT.pom.asc"
  cp "build/libs/plantuml-${RELEASE_VERSION}.jar.asc" "github_release/plantuml-SNAPSHOT.jar.asc"
  cp "build/libs/plantuml-${RELEASE_VERSION}-javadoc.jar.asc" "github_release/plantuml-SNAPSHOT-javadoc.jar.asc"
  cp "build/libs/plantuml-${RELEASE_VERSION}-sources.jar.asc" "github_release/plantuml-SNAPSHOT-sources.jar.asc"
  cp "build/libs/plantuml-pdf-${RELEASE_VERSION}.jar.asc" "github_release/plantuml-pdf-SNAPSHOT.jar.asc"
  cp "plantuml-mit/build/libs/plantuml-mit-${RELEASE_VERSION}.jar.asc" "github_release/plantuml-mit-SNAPSHOT.jar.asc"
  cp "plantuml-mit/build/libs/plantuml-mit-${RELEASE_VERSION}-sources.jar.asc" "github_release/plantuml-mit-SNAPSHOT-sources.jar.asc"
fi

echo -n "${DATE_TIME_UTC}" > "github_release/plantuml-SNAPSHOT.timestamp"

cat <<-EOF >notes.txt
  ## Version ~v${RELEASE_VERSION%-SNAPSHOT} of the ${DATE_TIME_UTC}
  This is a pre-release of [the latest development work](https://github.com/plantuml/plantuml/commits/).
  ⚠️  **It is not ready for general use** ⚠️
  ⏱  _Snapshot taken the ${DATE_TIME_UTC}_
EOF

gh release create \
  --prerelease \
  --target "${GITHUB_SHA}" \
  --title "${TAG} (~v${RELEASE_VERSION%-SNAPSHOT})" \
  --notes-file notes.txt \
  "${TAG}" github_release/*

echo "::notice title=release snapshot::Snapshot (~v${RELEASE_VERSION%-SNAPSHOT}) released at ${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/releases/tag/${TAG} and taken the ${DATE_TIME_UTC}"
