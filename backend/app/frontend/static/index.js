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

    fetch('http://localhost:8000/route/', {
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
        .then(data => {
            let routeGeoJSON = {
                "type": "Feature",
                "properties": {"cost": data.cost},

                "geometry": {
                    type: data.route.type,
                    coordinates: data.route.coordinates
                }
            };
            const routeStyle = {
                "color": "#4285F4",
                "weight": 5
            }

            if (displayedRoute){
                map.removeLayer(displayedRoute);
            }
            displayedRoute =  L.geoJSON(routeGeoJSON, {
                style: routeStyle
            }).addTo(map);
            routeExist = true;
            console.log("Route should be added")
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error finding route');
        });
})