// Function to show the popup message when the first button is clicked
function sayHello() {
    // Show the popup message
    alert("Now, click the next button to see an image!");
    
    // Show the second button
    document.getElementById("secondButton").style.display = "block";
}

// Function to show the image from the S3 bucket when the second button is clicked
function showImage() {
    // Set the image URL from the external source
    const imageUrl = "https://testgrid.io/blog/wp-content/uploads/2024/09/devops-testing.jpg"; 
    document.getElementById("image").src = imageUrl; // Set image source to the external URL
    document.getElementById("imageContainer").style.display = "block"; // Show the image
}