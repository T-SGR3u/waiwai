$(document).on('turbolinks:load', ()=> {

  const buildFileField = (index) => {
    const html = `<div class="js-file_group" data-index="${index}">
                    <input class="js-file" type="file" 
                    name="post[images_attributes][${index}][src]"
                    id="post_images_attributes_${index}_src">
                    <span class="js-remove">
                    削除
                    </span>
                  </div>`;
    return html;
  }
  let fileIndex = [1,2,3,4];

  $('#image-box').on('change', '.js-file', function(e) {
    $('#image-box').append(buildFileField(fileIndex[0]));
    fileIndex.shift();
    fileIndex.push(fileIndex[fileIndex.length - 1] + 1)
  });

  $("#image-box").on("click",".js-remove",function(){
    $(this).parent().remove();
    if ($(".js-file").length == 0) $("#image-box").append(buildFileField(fileIndex[0]));
  });
})