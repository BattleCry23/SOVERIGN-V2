<?php
$files = glob("pending/*.txt");
foreach($files as $file) {
    echo basename($file) . "\n";
}
?>
