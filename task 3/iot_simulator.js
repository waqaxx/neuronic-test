const bodyParser = require('body-parser');
const express = require('express');

const port = 3000;
const serverURL = 'serverUrl';
const authTokenForCloud = 'token-auth';
const authTokenForCurrentServer = 'current-server-auth-token';
const app = express();
const defaultFrequencyInSeconds = 5 * 60; // 5 minutes

const generateEnvironmentalData = () => {
    const temperature = Math.round(Math.random() * 50 - 10);
    const humidity = Math.round(Math.random() * 100);

    return {
        temperature,
        humidity
    }
}

const send = async (payload) => {
    console.log(`Sending data to cloud ${serverURL} => Temperature: ${payload.temperature}C Humidity: ${payload.humidity}% Token: ${payload.authTokenForCloud}`);

    // stringify payload and hit the server
    payload = JSON.stringify(payload);

    // possibly an axios or fetch request here which sends the payload to cloud on defined URL

};

const prepareAndSend = () => {
    const envData = generateEnvironmentalData();

    const dataToSend = {
        ...envData,
        authTokenForCloud: authTokenForCloud,
    };

    send(dataToSend);
}

let interval = setInterval(prepareAndSend, defaultFrequencyInSeconds * 1000); // Send every 5 minutes by default

// receives frequency in seconds
app.post('/update-frequency', bodyParser.json(), (req, res) => {
    const { frequency, authToken: freqAuthToken } = req.body;
    if (freqAuthToken != authTokenForCurrentServer) {
        return res.status(401).send('Unauthorized.');
    }

    if (frequency && !isNaN(frequency)) {
        clearInterval(interval);
        interval = setInterval(prepareAndSend, frequency * 1000);
        return res.send('Frequency updated successfully.');
    } else {
        return res.status(400).send('Frequency not found. Frequency needs to be in seconds.')
    }
});

app.listen(port, () => {
    console.log(`IOT simulator active on port ${port}`);
});