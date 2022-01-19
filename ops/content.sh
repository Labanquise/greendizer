#!/bin/sh

mkdir out/
mkdir out/tmp
mkdir out/pages

curl 'https://api.crystallize.com/labalise-dev/catalogue' \
  -H 'authority: api.crystallize.com' \
  -H 'pragma: no-cache' \
  -H 'cache-control: no-cache' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'sec-ch-ua-mobile: ?1' \
  -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Mobile Safari/537.36' \
  -H 'sec-ch-ua-platform: "Android"' \
  -H 'content-type: application/json' \
  -H 'accept: application/json' \
  -H 'origin: https://pim.crystallize.com' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://pim.crystallize.com/' \
  -H 'accept-language: fr,en-US;q=0.9,en;q=0.8' \
  --data-raw '{"query":"{\n  catalogue(language: \"en\", path: \"/pages\") {\n    name\n    children {\n      ... on Document {\n        name\n        shape {\n          name\n        }\n        title: component(id: \"meta-title\") {\n          content {\n            ... on SingleLineContent {\n              text\n            }\n          }\n        }\n        keywords: component(id: \"meta-keywords\") {\n          content {\n            ... on SingleLineContent {\n              text\n            }\n          }\n        }\n        menu: component(id: \"menu-title\") {\n          content {\n            ... on SingleLineContent {\n              text\n            }\n          }\n        }\n        components {\n          type\n          id\n          __typename\n          content {\n            ... on ContentChunkContent {\n              chunks {\n                name\n                id\n                type\n                content {\n                  ...on SingleLineContent {\n                    text\n                  }\n                  ... on ImageContent {\n                    firstImage {\n                      url\n                    }\n                  }\n                  ... on RichTextContent {\n                    html\n                  }\n                  ... on BooleanContent {\n                    value\n                  }\n                  ... on NumericContent {\n                    number\n                  }\n                  ... on PropertiesTableContent {\n                    sections {\n                      title\n                      properties {\n                        key\n                        value\n                      }\n                    }\n                  }\n                }\n              }\n            }\n          }\n        }\n      }\n    }\n  }\n}","variables":null}' \
  --compressed > out/tmp/raw.json

cat out/tmp/raw.json | ./ops/index.js # | jq --slurp '.' > out/pages.json
rm out/tmp/raw.json

for entry in "out/tmp"/*
do
  cat "$entry" | jq --slurp '.' | jq '.[]' > $(echo "$entry" | sed "s/tmp/pages/")
  rm "$entry"
done

rm -rf out/tmp/
mv out/pages/*.md content/
rm -rf out/