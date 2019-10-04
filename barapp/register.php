<?php
$con=mysqli_connect("db.soic.indiana.edu","i494f18_awilkeso","my+sql=i494f18_awilkeso","i494f18_awilkeso");
// Check connection
if (mysqli_connect_errno())
	{echo nl2br("Failed to connect to MySQL: " . mysqli_connect_error(). "\n "); }
else
	{echo nl2br("Established Database Connection\n");}

$sanfname = mysqli_real_escape_string($con,$_POST['firstName']);
$sanlname = mysqli_real_escape_string($con,$_POST['lastName']);
$sanusername = mysqli_real_escape_string($con,$_POST['username']);
$sanpassword = mysqli_real_escape_string($con,$_POST['password']);

$sql="INSERT INTO users (firstName,lastName,username,password) VALUES('$sanfname','$sanlname','$sanusername',SHA1('$sanpassword'))";

if (!mysqli_query($con,$sql))
{ die('Error: ' . mysqli_error($con)); }

echo "User successfully registered!";
mysqli_close($con);
?>
