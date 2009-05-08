switchPictureResolution = function(size) {
  var picture = $('picture');
  switch(size) {
  case 'small':
    picture.addClassName('picture_small');
    picture.removeClassName('picture_medium');
    picture.removeClassName('picture_full');
    break;
  case 'medium':
    picture.addClassName('picture_medium');
    picture.removeClassName('picture_small');
    picture.removeClassName('picture_full');
    break;
  case 'full':
    picture.addClassName('picture_full');
    picture.removeClassName('picture_medium');
    picture.removeClassName('picture_small');
    break;
  }
}

onImageMouseOver = function(anchor) {
  getPopup(anchor).show();
}
onImageMouseOut = function(anchor) {
  getPopup(anchor).hide();
}
onPopupMouseOver = function(popupDiv) {
  popupDiv.show();
}
onPopupMouseOut = function(popupDiv) {
  popupDiv.hide();
}
getPopup = function(anchor) {
  return anchor.parentNode.childElements().last()
}