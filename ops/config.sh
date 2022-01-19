
curl -s 'https://api.crystallize.com/labalise-dev/catalogue' \
  -H 'authority: api.crystallize.com' \
  -H 'pragma: no-cache' \
  -H 'cache-control: no-cache' \
  -H 'sec-ch-ua: " Not;A Brand";v="99", "Google Chrome";v="97", "Chromium";v="97"' \
  -H 'accept: */*' \
  -H 'content-type: application/json' \
  -H 'sec-ch-ua-mobile: ?1' \
  -H 'user-agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Mobile Safari/537.36' \
  -H 'sec-ch-ua-platform: "Android"' \
  -H 'origin: https://api.crystallize.com' \
  -H 'sec-fetch-site: same-origin' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://api.crystallize.com/labalise-dev/catalogue' \
  -H 'accept-language: fr,en-US;q=0.9,en;q=0.8' \
  -H 'cookie: mf_user=cf8e0b8b62fd66294b51a54585f23679|; _gid=GA1.2.1857004929.1642581319; _ga=GA1.2.1086028415.1623838472; mf_ea02c735-03a4-43dc-b476-f44b8a2fcced=da2ae6f40f4f93e5fe034a2b19965279|011920683a25514b55fe98070f6144c8eb96be93.1448416117.1642585460671$01192460baabaa6b2c07037efbb5a53408e0da63.-4438161469.1642585464962$0119398760c47da615d43917df766e5d8d900780.58577038.1642585479090$011907948f363adee6c24588f204cb7fdf4cf043.5924681382.1642585507496$011914029c0a64c8612b3c104f08d97a312fc946.3054595995.1642585514005|1642586902506||5|||1|17.57|97.30845; _ga_6151166MPX=GS1.1.1642598366.85.1.1642598692.0' \
  --data-raw '{"operationName":null,"variables":{},"query":"{\n  catalogue(language: \"en\", path: \"/site-config\") {\n    name\n    primaryColor: component(id: \"primary-color\") {\n      content {\n        ... on SingleLineContent {\n          text\n        }\n      }\n    }\n    secondaryColor: component(id: \"secondary-color\") {\n      content {\n        ... on SingleLineContent {\n          text\n        }\n      }\n    }\n    primaryTextColor: component(id: \"primary-text-color\") {\n      content {\n        ... on SingleLineContent {\n          text\n        }\n      }\n    }\n    secondaryTextColor: component(id: \"secondary-text-color\") {\n      content {\n        ... on SingleLineContent {\n          text\n        }\n      }\n    }\n  }\n}\n"}' \
  --compressed \
| jq '.data.catalogue | {"name":.name, "primaryColor": .primaryColor.content.text, "secondaryColor": .secondaryColor.content.text, "primaryTextColor":.primaryTextColor.content.text, "secondaryTextColor":.secondaryTextColor.content.text}' \
> data/config.json