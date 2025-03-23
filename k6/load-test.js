import http from "k6/http";
import { check, sleep } from "k6";
import { randomSeed, randomIntBetween } from "k6";

randomSeed(__VU);

export const options = {
  vus: 5,
  duration: "10m",
};

const BASE_URL = "http://spring-petclinic:8080";

// Manual URL-encoding function
function encodeForm(data) {
  return Object.keys(data)
    .map((key) => encodeURIComponent(key) + "=" + encodeURIComponent(data[key]))
    .join("&");
}

export default function () {
  // 1. Home page
  let res = http.get(`${BASE_URL}/`);
  check(res, { "home page ok": (r) => r.status === 200 });
  sleep(1);

  // 2. Vets
  res = http.get(`${BASE_URL}/vets.html`);
  check(res, { "vets page ok": (r) => r.status === 200 });
  sleep(1);

  // 3. Find owners
  res = http.get(`${BASE_URL}/owners/find`);
  check(res, { "find owner page ok": (r) => r.status === 200 });
  sleep(1);

  res = http.get(`${BASE_URL}/owners?lastName=`);
  check(res, { "owners search results ok": (r) => r.status === 200 });
  sleep(1);

  // 4. Owner detail
  res = http.get(`${BASE_URL}/owners?lastName=`);

  let ownerId = null;
  const idRegex = /\/owners\/(\d+)/g;
  let match = idRegex.exec(res.body);

  if (match && match[1]) {
    ownerId = match[1];
  }

  if (ownerId) {
    const ownerDetailRes = http.get(`${BASE_URL}/owners/${ownerId}`);

    if (
      ownerDetailRes &&
      typeof ownerDetailRes === "object" &&
      "status" in ownerDetailRes
    ) {
      check(ownerDetailRes, { "owner detail ok": (r) => r.status === 200 });
    } else {
      console.warn(
        `⚠️ Failed to fetch owner ${ownerId}. Response:`,
        JSON.stringify(ownerDetailRes)
      );
    }
  } else {
    console.warn("⚠️ No owner ID found in search results.");
  }

  // 5. Occasionally create new owner
  if (Math.random() < 0.1) {
    res = http.get(`${BASE_URL}/owners/new`);
    check(res, { "new owner page ok": (r) => r.status === 200 });
    sleep(1);

    const firstName = `Test${Math.random().toString(36).substring(7)}`;
    const formData = {
      firstName,
      lastName: "Loadtest",
      address: "123 Street",
      city: "City",
      telephone: "1234567890",
    };

    const payload = encodeForm(formData);

    res = http.post(`${BASE_URL}/owners/new`, payload, {
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
    });

    console.log(`📬 Submitted owner: ${firstName}, status: ${res.status}`);

    check(res, {
      "owner POST handled": (r) =>
        r.status === 200 || r.status === 302 || r.status === 400,
    });

    sleep(1);
  }

  // 6. Error page
  res = http.get(`${BASE_URL}/oups`);
  check(res, { "oups page ok": (r) => r.status === 200 });
  sleep(1);
}
