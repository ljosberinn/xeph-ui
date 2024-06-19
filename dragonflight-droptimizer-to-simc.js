const [goToEquippedDroptimizerButton] = $$("button.Button").filter(
  (button) => button.textContent === "Go to equipped"
);
const panel = goToEquippedDroptimizerButton.closest(".Panel");
const list = panel.lastChild.lastChild;

const result = [];

for (let i = 0; i < list.childElementCount; i++) {
  const child = list.childNodes[i];
  const parentFlex = child.lastChild.firstChild;
  const [percentage] = Array.from(parentFlex.querySelectorAll("p.Text"))
    .filter((p) => p.textContent.endsWith("%"))
    .map((p) => p.textContent.slice(0, -1));

  if (percentage.startsWith("-") || percentage === "—") {
    continue;
  }

  const firstChildFlex = parentFlex.querySelector("div.Flex");
  const [itemNameText, itemLevelText, slotText] =
    firstChildFlex.querySelectorAll("p.Text");
  const itemName = itemNameText.textContent;
  const itemLevel = itemLevelText.textContent;

  let slot = slotText.textContent.toLowerCase().split(" ").join("_");

  if (slot.includes("finger") || slot.includes("trinket")) {
    slot = slot.replace("_", "");
  }

  const url = new URL(parentFlex.querySelector("a").href);
  const itemId = url.pathname.replace("/item=", "");

  const bonusIds = (url.searchParams.get("bonus") ?? "").split(":").join("/");
  const craftedStats = (url.searchParams.get("crafted-stats") ?? "")
    .split(":")
    .join("/");
  const craftingQuality = url.searchParams.get("crafting-quality");
  const enchant = url.searchParams.get("ench");
  const gems = url.searchParams.get("gems");

  result.push(`# ${itemName} (${itemLevel})`);

  const entry = [
    `${slot}=`,
    `id=${itemId}`,
    `bonus_id=${bonusIds}`,
    `crafting_quality=${craftingQuality > 5 ? 5 : craftingQuality}`,
    `crafted_stats=${craftedStats}`,
    enchant ? `enchant_id=${enchant}` : null,
    gems ? `gem_id=${gems}` : null,
  ]
    .filter(Boolean)
    .join(",");

  result.push(`# ${entry}`);
  result.push("#");
}

copy(result.join("\n"));
