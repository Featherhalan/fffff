# obfuscate.ps1 — Encodes index.html with XOR+Base64 and writes a loader
$src = [System.IO.File]::ReadAllBytes("index.html")
$key = @(0x4F, 0x71, 0x38, 0xA2, 0x1D, 0x55, 0xC3, 0x7E)
$enc = for ($i = 0; $i -lt $src.Length; $i++) { $src[$i] -bxor $key[$i % $key.Length] }
$b64 = [Convert]::ToBase64String([byte[]]$enc)

$loader = @"
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Feather Softworks</title></head>
<body style="margin:0;background:#050507">
<script>
(function(){
var _k=[0x4F,0x71,0x38,0xA2,0x1D,0x55,0xC3,0x7E];
var _b="$b64";
var _bin=atob(_b);
var _r=new Uint8Array(_bin.length);
for(var i=0;i<_bin.length;i++){_r[i]=_bin.charCodeAt(i)^_k[i%_k.length];}
var _s=new TextDecoder('utf-8').decode(_r);
document.open('text/html','replace');document.write(_s);document.close();
})();
</script>
</body></html>
"@

[System.IO.File]::WriteAllText("index.html", $loader, [System.Text.Encoding]::UTF8)
Write-Host "Done. Encoded $($src.Length) bytes."
