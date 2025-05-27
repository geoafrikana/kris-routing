var map = L.map('map').setView([3.82, 11.53], 12);
L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);

map.addEventListener('click', function (e) {
    alert(e.latlng)
})

const form = document.getElementById('form');
let source_lat, source_lon, dest_lat, dest_lon;
let displayedRoute;


const body = { source_lat, source_lon, dest_lat, dest_lon }
form.addEventListener('submit', function (e) {
    e.preventDefault();
    source_lat = parseFloat(document.getElementById('source_lat').value);
    source_lon = parseFloat(document.getElementById('source_lng').value);
    dest_lat = parseFloat(document.getElementById('dest_lat').value);
    dest_lon = parseFloat(document.getElementById('dest_lng').value);

    fetch('/route/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ source_lat, source_lon, dest_lat, dest_lon })
    })
        .then(async response => {
            if (!response.ok) {
                const error = await response.json();
                throw new Error(error.detail || 'Unknown error');
            }
            return response.json()
        })
        .then(async data => {
            // var line= turf.lineString(data.route.coordinates);
            // console.log(line)
            let routeGeoJSON = {
                "type": "Feature",
                "properties": {"duration_seconds": data.duration_seconds},

                "geometry": {
                    type: data.route.type,
                    coordinates: data.route.coordinates
                }
            };
            // You can use other units like "miles". see https://turfjs.org/docs/api/length 
            routeGeoJSON.properties.distance = await turf.length(routeGeoJSON, {units: 'kilometers'})
            const routeStyle = {
                "color": "#4285F4",
                "weight": 5
            }

            if (displayedRoute){
                map.removeLayer(displayedRoute);
            }
            displayedRoute =  L.geoJSON(routeGeoJSON, {
                style: routeStyle,
                onEachFeature: function(feature, layer){
                    console.log(feature.properties.distance)
                    layer.bindPopup(
                        `<b>Duration:</b> ${formatDuration(feature.properties.duration_seconds)}
                        </br>
                        <b>Distance:</b> ${feature.properties.distance.toFixed(2)} km`);
                }
            }).addTo(map)
            routeExist = true;
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error finding route');
        });
})

const formatDuration=  function formatDuration(seconds) {
  const totalSeconds = Math.floor(seconds);
  const minutes = Math.floor(totalSeconds / 60);
  const remainingSeconds = totalSeconds % 60;

  if (minutes > 0) {
    return `${minutes} minute${minutes !== 1 ? 's' : ''} ${remainingSeconds} second${remainingSeconds !== 1 ? 's' : ''}`;
  } else {
    return `${remainingSeconds} second${remainingSeconds !== 1 ? 's' : ''}`;
  }
}
