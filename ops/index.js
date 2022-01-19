#!/usr/bin/node
const fs = require("fs");

class Page {}
class Block {}
class Section {}
class Item {}

var stdin = process.openStdin();
var data = "";
stdin.on("data", function (chunk) {
  data += chunk;
});

function haveAShape(item) {
  return item["shape"] != undefined;
}

function isContentChunkAndNotNull(chunk) {
  if (chunk["type"] != "contentChunk") return false;
  if (chunk["content"] == null) return false;
  return true;
}

function isNotNull(component) {
  if (component["content"] == null) return false;
  return true;
}

stdin.on("end", function () {
  var raw = JSON.parse(data);
  raw["data"]["catalogue"]["children"].forEach((item) => {
    if (!haveAShape(item)) return;

    const page = new Page();
    page.name = item["name"];
    page.title = item["title"]["content"]["text"];
    page.keywords = item["keywords"]["content"]["text"];
    page.menu = item["menu"]["content"]["text"];

    page.blocks = Array();
    item.components.forEach((c) => {
      if (!isContentChunkAndNotNull(c)) return;

      c.content.chunks.forEach((chunk) => {
        const block = new Block();
        block.type = c.id;

        chunk.forEach((component) => {
          if (!isNotNull(component)) return;
          
          switch (component.type) {
            case "singleLine":
              block[component.id] = component.content.text;
              break;
            case "images":
              block[component.id] = component.content.firstImage.url;
              break;
            case "richText":
              block[component.id] = "";
              component.content.html.forEach((html) => {
                block[component.id] = block[component.id] + html;
              });
              break;
            case "propertiesTable":
              componentlist = Array();
              component.content.sections.forEach((sec) => {
                const prop = new Item();
                sec.properties.forEach((p) => {
                  prop[p.key] = p.value;
                });
                if (prop.title != null) {
                  const section = new Section();
                  section[sec.title] = prop;
                  componentlist.push(section);
                }
              });
              if (componentlist.length > 0) {
                block[component.id] = componentlist;
              }
              break;
            case "boolean":
              block[component.id] = component.content.value;
              break;
            case "numeric":
              block[component.id] = component.content.number;
              break;
          }
        });
        page.blocks.push(block);
      });
    });
    page.blocks.sort(compare);
    console.log(JSON.stringify(page));

    fs.writeFileSync(
      `out/tmp/${page.name.toLowerCase().replace(' ', '-')}.md`,
      JSON.stringify(page),
      function (err) {
        if (err) {
          return console.log("error");
        }
      }
    );
  });
});

function compare(a, b) {
  if (a.weight < b.weight) {
    return -1;
  }
  if (a.weight > b.weight) {
    return 1;
  }
  return 0;
}
