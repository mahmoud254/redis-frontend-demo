const BACKEND_URL = "http://localhost:3001"
const ENDPOINT = "imagesHour"

document.addEventListener("DOMContentLoaded", async () => {
    console.log("Loaded");
    let imageUri;
    try {
        const res = await axios({
            method: 'get',
            url: `${BACKEND_URL}/${ENDPOINT}`,
            params: {}
        });
        // console.log(res.data);
        // console.log("-------------------");
        // console.log(res.status);
        if (res.status === 200) {
            imageUri = res.data.singleURL
        }else{
            imageUri = './error.jpg'
        }
    }catch(err) {
        imageUri = './error.jpg'
    }    

    document.body.innerHTML += `<img src="${imageUri}" alt="Image" width="500" height="600"> `
});