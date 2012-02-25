<script>
$('a[data-popup='true']').live('click', function(e) {
      window.open($(this).href);
      e.preventDefault();
   });
</script>


