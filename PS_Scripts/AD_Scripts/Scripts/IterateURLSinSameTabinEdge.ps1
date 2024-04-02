# Define the URLs to switch between
$urls = @("https://www.bing.com", "https://www.microsoft.com")

# Create an IE object and make it visible
$ie = New-Object -ComObject "InternetExplorer.Application"
$ie.Visible = $true

# Loop indefinitely
while ($true) {
  # Iterate over the URLs
  foreach ($url in $urls) {
    # Navigate to the URL and refresh the page
    $ie.Navigate2($url)
    $ie.Refresh()
    # Wait for 60 seconds
    Start-Sleep -Seconds 60
  }
}
