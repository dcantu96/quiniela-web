export function getMetaValue(name) {
  const element = findElement(document.head, `meta[name="${name}"]`)
  if (element) {
    return element.getAttribute("content")
  }
}

export function findElement(root, selector) {
  if (typeof root == "string") {
    selector = root
    root = document
  }
  return root.querySelector(selector)
}

export function toArray(value) {
  if (Array.isArray(value)) {
    return value
  } else if (Array.from) {
    return Array.from(value)
  } else {
    return [].slice.call(value)
  }
}

export function removeElement(el) {
  if (el && el.parentNode) {
    el.parentNode.removeChild(el);
  }
}

export function insertAfter(el, referenceNode) {
    return referenceNode.parentNode.insertBefore(el, referenceNode.nextSibling);
}