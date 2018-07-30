<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>全景</title>
	<script src="https://aframe.io/releases/0.3.0/aframe.min.js"></script>
</head>
<body>
    <a-scene>
        <a-assets>
            <img id="lake" src="/street.jpg">
        </a-assets>
        <a-sky src="#lake"></a-sky>
    </a-scene>
</body>
</html>
