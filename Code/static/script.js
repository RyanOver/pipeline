// Display today date
const theDate = document.querySelector('#date');

let todayDate = new Date()

let dayString = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
let monthString = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',            'September', 'October', 'November', 'December']

let day = todayDate.getDay()
let date = todayDate.getUTCDate()
let month = todayDate.getUTCMonth()
let year = todayDate.getUTCFullYear()

let laDate = theDate.innerHTML = `${dayString[day]} ${date}, ${monthString[month]} ${year}`

// Display the Current TIme
const theTime = document.querySelector('#time');

setInterval(displayTime, 1000);
function displayTime() {
    let currentTime = new Date();
    let hours = currentTime.getHours();
    let minutes = currentTime.getMinutes();
    let secondes = currentTime.getSeconds();

    if (hours < 10) {
    hours = "0" + hours;
    }
    if (minutes < 10) {
    minutes = "0" + minutes;
    }
    if (secondes < 10) {
    secondes = "0" + secondes;
    }

    let a = theTime.innerHTML = hours + ':' + minutes + '.' + secondes;
}

// Display weather forecast
let forecast = document.querySelector('#weather')

let api_id_key = 'cc6566b18fb703c7c5f1928bd738a82c'
let weather_url = `https://api.openweathermap.org/data/2.5/weather?q=Montreal&appid=${api_id_key}&units=metric`

async function getWeather() 
{
  let response = await fetch(weather_url);
  let data = await response.json()
  console.log(data)
  return data;
}


let weatherData = getWeather()
  .then(data => {
      let desc = data.weather[0].description;
      let temp = Math.ceil(data.main.temp);
      let b = forecast.innerHTML = `${temp}&#176;  ${desc}`;
    }).catch(console.error);

