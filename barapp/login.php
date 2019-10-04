
<?php
$con=mysqli_connect("db.soic.indiana.edu","i494f18_awilkeso","my+sql=i494f18_awilkeso","i494f18_awilkeso");
// Check connection
if (mysqli_connect_errno())
	{echo nl2br("Failed to connect to MySQL: " . mysqli_connect_error(). "\n "); }
else
	{echo nl2br("Established Database Connection\n");}

$sql = "SELECT firstName, lastName, username FROM users";
$result = mysqli_query($con, $sql);
		//checking if it was getting the correct info from the database
    // echo "<table border='1'";
    // echo "<tr><th>Name</th><th>Username</th></tr>";
    // while($row = mysqli_fetch_assoc($result)) {
    //     echo "<tr><td>{$row['firstName']}{$row['lastName']}</td><td>{$row['username']}</td></tr>";
    // }
		//
    // echo "</table>";

		$sanusername = mysqli_real_escape_string($con,$_POST['username']);
		$sanpassword = mysqli_real_escape_string($con,$_POST['password']);
		$secure_password = md5($sanpassword);

		$result = mysql_query("SELECT username, password FROM users WHERE username=$sanusername AND password=$secure_password");
		if ($result != null && (mysqli_num_rows($result) = 1)) {
				$phpresult = "true";
		}
		echo $phpresult

mysqli_close($con);
?>
