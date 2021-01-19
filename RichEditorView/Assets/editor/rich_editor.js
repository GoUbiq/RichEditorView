/**
 * Copyright (C) 2015 Wasabeef
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 "use strict";

const RE = {};

RE.editor = document.getElementById('editor');

// Not universally supported, but seems to work in iOS 7 and 8
document.addEventListener("selectionchange", function() {
    RE.backuprange();
});

//looks specifically for a Range selection and not a Caret selection
RE.rangeSelectionExists = function() {
    //!! coerces a null to bool
    var sel = document.getSelection();
    if (sel && sel.type == "Range") {
        return true;
    }
    return false;
};

RE.rangeOrCaretSelectionExists = function() {
    //!! coerces a null to bool
    var sel = document.getSelection();
    if (sel && (sel.type == "Range" || sel.type == "Caret")) {
        return true;
    }
    return false;
};

RE.editor.addEventListener("input", function() {
    RE.updatePlaceholder();
    RE.backuprange();
    RE.callback("input");
});

RE.editor.addEventListener("focus", function() {
    RE.backuprange();
    RE.callback("focus");
});

RE.editor.addEventListener("blur", function() {
    RE.callback("blur");
});

RE.customAction = function(action) {
    RE.callback("action/" + action);
};

RE.updateHeight = function() {
    RE.callback("updateHeight");
}

RE.callbackQueue = [];
RE.runCallbackQueue = function() {
    if (RE.callbackQueue.length === 0) {
        return;
    }

    setTimeout(function() {
        window.location.href = "re-callback://";
        //window.webkit.messageHandlers.iOS_Native_FlushMessageQueue.postMessage("re-callback://")
    }, 0);
};

RE.getCommandQueue = function() {
    var commands = JSON.stringify(RE.callbackQueue);
    RE.callbackQueue = [];
    return commands;
};

RE.callback = function(method) {
    RE.callbackQueue.push(method);
    RE.runCallbackQueue();
};

RE.setHtml = function(contents) {
    var tempWrapper = document.createElement('div');
    tempWrapper.innerHTML = contents;
    var images = tempWrapper.querySelectorAll("img");

    for (var i = 0; i < images.length; i++) {
        images[i].onload = RE.updateHeight;
    }

    RE.editor.innerHTML = tempWrapper.innerHTML;
    RE.updatePlaceholder();
};

RE.getHtml = function() {
    return RE.editor.innerHTML;
};

RE.getText = function() {
    return RE.editor.innerText;
};

RE.setBaseTextColor = function(color) {
    RE.editor.style.color  = color;
};

RE.setPlaceholderText = function(text) {
    RE.editor.setAttribute("placeholder", text);
};

RE.updatePlaceholder = function() {
    if (RE.editor.innerHTML.indexOf('img') !== -1 || RE.editor.innerHTML.length > 0) {
        RE.editor.classList.remove("placeholder");
    } else {
        RE.editor.classList.add("placeholder");
    }
};

RE.removeFormat = function() {
    document.execCommand('removeFormat', false, null);
};

RE.setFontSize = function(size) {
    RE.editor.style.fontSize = size;
};

RE.setBackgroundColor = function(color) {
    RE.editor.style.backgroundColor = color;
};

RE.setHeight = function(size) {
    RE.editor.style.height = size;
};

RE.undo = function() {
    document.execCommand('undo', false, null);
};

RE.redo = function() {
    document.execCommand('redo', false, null);
};

RE.setBold = function() {
    document.execCommand('bold', false, null);
};

RE.setItalic = function() {
    document.execCommand('italic', false, null);
};

RE.setSubscript = function() {
    document.execCommand('subscript', false, null);
};

RE.setSuperscript = function() {
    document.execCommand('superscript', false, null);
};

RE.setStrikeThrough = function() {
    document.execCommand('strikeThrough', false, null);
};

RE.setUnderline = function() {
    document.execCommand('underline', false, null);
};

RE.setTextColor = function(color) {
    RE.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('foreColor', false, color);
    document.execCommand("styleWithCSS", null, false);
};

RE.setTextBackgroundColor = function(color) {
    RE.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('hiliteColor', false, color);
    document.execCommand("styleWithCSS", null, false);
};

RE.setHeading = function(heading) {
    document.execCommand('formatBlock', false, '<h' + heading + '>');
};

RE.setIndent = function() {
    document.execCommand('indent', false, null);
};

RE.setOutdent = function() {
    document.execCommand('outdent', false, null);
};

RE.setOrderedList = function() {
    document.execCommand('insertOrderedList', false, null);
};

RE.setUnorderedList = function() {
    document.execCommand('insertUnorderedList', false, null);
};

RE.setJustifyLeft = function() {
    document.execCommand('justifyLeft', false, null);
};

RE.setJustifyCenter = function() {
    document.execCommand('justifyCenter', false, null);
};

RE.setJustifyRight = function() {
    document.execCommand('justifyRight', false, null);
};

RE.getLineHeight = function() {
    return RE.editor.style.lineHeight;
};

RE.setLineHeight = function(height) {
    RE.editor.style.lineHeight = height;
};

RE.insertImage = function(url, textTags, alt) {
    var tagJson = JSON.parse(textTags);
    var width = RE.editor.clientWidth - 20
    var finalTT = addTextTags(false, tagJson.textTags).join();
    var html = `<div>
                    <div class="dkfTmI" contenteditable="false">
                        <div class="jeDXud">
                            <img src="${url}" alt="${alt}" width=${width}px>
                        </div>
                        ${finalTT}
                    </div>
                </div>
                <br><br><br>`;

    
    RE.insertHTML(html);
    RE.callback("input");
};

RE.insertVideo = function(url, alt) {
//    var vid = document.createElement('video');
//    vid.setAttribute("src", url)
//    vid.setAttribute("alt", alt)
//    vid.setAttribute('playsinline', true)
//    vid.setAttribute('webkit-playsinline', true)
//    vid.setAttribute('autoplay', true)
//    vid.setAttribute('loop', true)
//    vid.setAttribute('muted', true)
//    vid.setAttribute('width', RE.editor.clientWidth - 20)

    
    var html = '<div class="dkfTmI"><div class="jeDXud"><video src="' + url + '" alt="' + alt + '" width=' + (RE.editor.clientWidth - 20) + 'px playsinline webkit-playsinline autoplay loop muted></div>' + '</div>';
    
//    vid.onload = RE.updateHeight;
    
    RE.insertHTML(html);
    RE.callback("input");
}

function addTextTags(hideMe, textTags) {
    return(
       textTags.map(tag => {
          const { text, anchorUrl, boxBackgroundColor,
          textColor, fontSize, anchorSide } = tag;
          let dotLeft = "2px";
          let dotRight = "auto";
          let dotLeftPosn = `calc(${tag.positionX * 100}%)`;
          let dotRightPosn = 'auto';
          let boxLeft = "10px";
          let boxRight = "auto";
          let transformOrigin = "left top";
          if (anchorSide === "RIGHT") {
             dotLeft = "auto";
             dotRight = "2px";
             dotLeftPosn = 'auto';
             dotRightPosn =`calc(${(1-tag.positionX) * 100}%)`;
             boxLeft = "auto";
             boxRight = "10px";
             transformOrigin = "right top";
          }
          const outerDiv = `style="top: calc(${tag.positionY * 100}%)}; left: ${dotLeftPosn}; right: ${dotRightPosn};"`;
          const dotDiv = `style="left: ${dotLeft}; right: ${dotRight};"`;
          const dotDiv2 = `style="left: ${dotLeft}; right: ${dotRight};"`;
          return`
             <div class="gXPAyA">
                <div class="gQyvwo" ${outerDiv}>
                   <div class="jBnbzw" ${dotDiv}></div>
                   <div class="kumRIm" ${dotDiv2}></div>
                   <a href="#">
                      <div class="bntKdk" style="background: ${boxBackgroundColor}; left: ${boxLeft}; right: ${boxRight}; transform-origin:${transformOrigin};">
                         <div class="fngueF" style="overflow: inherit; height: auto; max-height: inherit; display: block; color: ${textColor}; font-size: ${fontSize};">${text}</div>
                      </div>
                   </a>
                </div>
             </div>`;
       })
    );
}

RE.insertTag = function(textTags) {
    
}

RE.setBlockquote = function() {
    document.execCommand('formatBlock', false, '<blockquote>');
};

RE.insertHTML = function(html) {
    RE.restorerange();
    document.execCommand('insertHTML', false, html);
};

RE.insertLink = function(url, title) {
    RE.restorerange();
    var sel = document.getSelection();
    if (sel.toString().length !== 0) {
        if (sel.rangeCount) {

            var el = document.createElement("a");
            el.setAttribute("href", url);
            el.setAttribute("title", title);

            var range = sel.getRangeAt(0).cloneRange();
            range.surroundContents(el);
            sel.removeAllRanges();
            sel.addRange(range);
        }
    }
    RE.callback("input");
};

RE.prepareInsert = function() {
    RE.backuprange();
};

RE.backuprange = function() {
    var selection = window.getSelection();
    if (selection.rangeCount > 0) {
        var range = selection.getRangeAt(0);
        RE.currentSelection = {
            "startContainer": range.startContainer,
            "startOffset": range.startOffset,
            "endContainer": range.endContainer,
            "endOffset": range.endOffset
        };
    }
};

RE.addRangeToSelection = function(selection, range) {
    if (selection) {
        selection.removeAllRanges();
        selection.addRange(range);
    }
};

// Programatically select a DOM element
RE.selectElementContents = function(el) {
    var range = document.createRange();
    range.selectNodeContents(el);
    var sel = window.getSelection();
    // this.createSelectionFromRange sel, range
    RE.addRangeToSelection(sel, range);
};

RE.restorerange = function() {
    var selection = window.getSelection();
    selection.removeAllRanges();
    var range = document.createRange();
    range.setStart(RE.currentSelection.startContainer, RE.currentSelection.startOffset);
    range.setEnd(RE.currentSelection.endContainer, RE.currentSelection.endOffset);
    selection.addRange(range);
};

RE.focus = function() {
    var range = document.createRange();
    range.selectNodeContents(RE.editor);
    range.collapse(false);
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    RE.editor.focus();
};

RE.focusAtPoint = function(x, y) {
    var range = document.caretRangeFromPoint(x, y) || document.createRange();
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    RE.editor.focus();
};

RE.blurFocus = function() {
    RE.editor.blur();
};

/**
Recursively search element ancestors to find a element nodeName e.g. A
**/
var _findNodeByNameInContainer = function(element, nodeName, rootElementId) {
    if (element.nodeName == nodeName) {
        return element;
    } else {
        if (element.id === rootElementId) {
            return null;
        }
        _findNodeByNameInContainer(element.parentElement, nodeName, rootElementId);
    }
};

var isAnchorNode = function(node) {
    return ("A" == node.nodeName);
};

RE.getAnchorTagsInNode = function(node) {
    var links = [];

    while (node.nextSibling !== null && node.nextSibling !== undefined) {
        node = node.nextSibling;
        if (isAnchorNode(node)) {
            links.push(node.getAttribute('href'));
        }
    }
    return links;
};

RE.countAnchorTagsInNode = function(node) {
    return RE.getAnchorTagsInNode(node).length;
};

/**
 * If the current selection's parent is an anchor tag, get the href.
 * @returns {string}
 */
RE.getSelectedHref = function() {
    var href, sel;
    href = '';
    sel = window.getSelection();
    if (!RE.rangeOrCaretSelectionExists()) {
        return null;
    }

    var tags = RE.getAnchorTagsInNode(sel.anchorNode);
    //if more than one link is there, return null
    if (tags.length > 1) {
        return null;
    } else if (tags.length == 1) {
        href = tags[0];
    } else {
        var node = _findNodeByNameInContainer(sel.anchorNode.parentElement, 'A', 'editor');
        href = node.href;
    }

    return href ? href : null;
};

// Returns the cursor position relative to its current position onscreen.
// Can be negative if it is above what is visible
RE.getRelativeCaretYPosition = function() {
    var y = 0;
    var sel = window.getSelection();
    if (sel.rangeCount) {
        var range = sel.getRangeAt(0);
        var needsWorkAround = (range.startOffset == 0)
        /* Removing fixes bug when node name other than 'div' */
        // && range.startContainer.nodeName.toLowerCase() == 'div');
        if (needsWorkAround) {
            y = range.startContainer.offsetTop - window.pageYOffset;
        } else {
            if (range.getClientRects) {
                var rects = range.getClientRects();
                if (rects.length > 0) {
                    y = rects[0].top;
                }
            }
        }
    }

    return y;
};

window.onload = function() {
    RE.callback("ready");
};

RE.insertProductTag = function(name, url, star) {
    var emptyStar = '<li class="ilbvwk" style="height: 12px; margin-right: 4px;"><svg width="12" height="12" viewBox="0 0 12 12" fill="#C8CACC" xmlns="http://www.w3.org/2000/svg" style="width: 12px; height: 12px; display: block;"><path d="M11.2632 5.5454C11.4842 5.29708 11.5558 4.95571 11.4556 4.63327C11.3555 4.31083 11.1044 4.07928 10.7859 4.01382L8.22407 3.4858C8.18671 3.47808 8.1514 3.46198 8.12058 3.43863C8.08977 3.41528 8.06419 3.38522 8.04561 3.35055L6.77248 0.972296C6.61373 0.676908 6.32477 0.5 6 0.5C5.67523 0.5 5.38627 0.676367 5.22803 0.972837L3.95491 3.35055C3.93617 3.38509 3.91054 3.41503 3.87975 3.43837C3.84896 3.4617 3.81374 3.47787 3.77645 3.4858L1.21412 4.01382C0.89558 4.07982 0.644483 4.31137 0.544356 4.63381C0.444229 4.95625 0.515822 5.29762 0.736829 5.54594L2.51214 7.54387C2.53794 7.57291 2.55738 7.60744 2.56912 7.64509C2.58085 7.68273 2.5846 7.72259 2.58011 7.76189L2.26987 10.4664C2.25005 10.6295 2.27291 10.7951 2.33602 10.9458C2.39913 11.0965 2.50014 11.2266 2.62835 11.3222C2.75532 11.4194 2.90504 11.4791 3.06178 11.4951C3.21852 11.5111 3.37651 11.4828 3.51912 11.4131L5.8895 10.27C5.92399 10.2534 5.96151 10.2449 5.99948 10.2449C6.03745 10.2449 6.07497 10.2534 6.10947 10.27L8.47984 11.4131C8.62238 11.4831 8.78042 11.5117 8.93723 11.4957C9.09404 11.4797 9.24379 11.4197 9.37061 11.3222C9.49903 11.2268 9.6002 11.0967 9.66333 10.946C9.72647 10.7953 9.74919 10.6295 9.7291 10.4664L9.41886 7.76243C9.41417 7.72299 9.41788 7.68296 9.42972 7.64519C9.44155 7.60741 9.46123 7.57282 9.48734 7.54387L11.2632 5.5454Z" fill-opacity="0.5"></path></svg></li>';
    var fullStar = '<li class="ilbvwk" style="height: 12px; margin-right: 4px;"><svg width="12" height="12" viewBox="0 0 12 12" fill="#FFB800" xmlns="http://www.w3.org/2000/svg" style="width: 12px; height: 12px; display: block;"><path d="M11.2632 5.5454C11.4842 5.29708 11.5558 4.95571 11.4556 4.63327C11.3555 4.31083 11.1044 4.07928 10.7859 4.01382L8.22407 3.4858C8.18671 3.47808 8.1514 3.46198 8.12058 3.43863C8.08977 3.41528 8.06419 3.38522 8.04561 3.35055L6.77248 0.972296C6.61373 0.676908 6.32477 0.5 6 0.5C5.67523 0.5 5.38627 0.676367 5.22803 0.972837L3.95491 3.35055C3.93617 3.38509 3.91054 3.41503 3.87975 3.43837C3.84896 3.4617 3.81374 3.47787 3.77645 3.4858L1.21412 4.01382C0.89558 4.07982 0.644483 4.31137 0.544356 4.63381C0.444229 4.95625 0.515822 5.29762 0.736829 5.54594L2.51214 7.54387C2.53794 7.57291 2.55738 7.60744 2.56912 7.64509C2.58085 7.68273 2.5846 7.72259 2.58011 7.76189L2.26987 10.4664C2.25005 10.6295 2.27291 10.7951 2.33602 10.9458C2.39913 11.0965 2.50014 11.2266 2.62835 11.3222C2.75532 11.4194 2.90504 11.4791 3.06178 11.4951C3.21852 11.5111 3.37651 11.4828 3.51912 11.4131L5.8895 10.27C5.92399 10.2534 5.96151 10.2449 5.99948 10.2449C6.03745 10.2449 6.07497 10.2534 6.10947 10.27L8.47984 11.4131C8.62238 11.4831 8.78042 11.5117 8.93723 11.4957C9.09404 11.4797 9.24379 11.4197 9.37061 11.3222C9.49903 11.2268 9.6002 11.0967 9.66333 10.946C9.72647 10.7953 9.74919 10.6295 9.7291 10.4664L9.41886 7.76243C9.41417 7.72299 9.41788 7.68296 9.42972 7.64519C9.44155 7.60741 9.46123 7.57282 9.48734 7.54387L11.2632 5.5454Z"></path></svg></li>';
    var finalStar = '';
    var i = 0;
    while (i < star) {
        finalStar += fullStar;
        i++;
    }
    while (i < 5) {
        finalStar += emptyStar;
        i++;
    }
    var html = '<a href="'+ url +'"> <span class="iipeUt"> '+ name +' <div class="bOvYHH"></div> <ul class="gvdZSq LnxYN" style="height: 12px; line-height: 1;"> '+ finalStar +' </ul> </span> </a><br>';
    RE.insertHTML(html);
}

