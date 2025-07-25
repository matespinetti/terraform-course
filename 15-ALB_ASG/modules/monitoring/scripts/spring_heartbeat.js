import { URL } from "url";
import { synthetics } from "@amzn/synthetics-playwright";

const loadBlueprints = async function () {
  // Use the template variable from Terraform
  const urls = ["${endpoint_url}"];

  const browser = await synthetics.launch();
  const browserContext = await browser.newContext();
  let page = await synthetics.newPage(browserContext);

  for (const url of urls) {
    await loadUrl(page, url);
  }

  // Ensure browser is closed
  await synthetics.close();
};

// Reset the page in-between
const resetPage = async function (page) {
  try {
    // Set page.goto timeout to 30 seconds, adjust as needed
    await page.goto("about:blank", { waitUntil: "load", timeout: 30000 });
  } catch (e) {
    console.error("Unable to open a blank page. ", e);
  }
};

const loadUrl = async function (page, url) {
  let stepName = null;
  let domcontentloaded = false;

  try {
    stepName = new URL(url).hostname;
  } catch (e) {
    const errorString = `Error parsing url: $${url}. $${e}`;
    console.error(errorString);
    throw e;
  }

  await synthetics.executeStep(stepName, async function () {
    try {
      const response = await page.goto(url, {
        waitUntil: "load",
        timeout: 30000,
      });

      if (response) {
        domcontentloaded = true;
        const status = response.status();
        console.log(`Response status: $${status}`);

        // If the response status code is not a 2xx success code
        if (status < 200 || status > 299) {
          console.error(`Failed to load url: $${url}, status code: $${status}`);
          throw new Error("Failed");
        }
      } else {
        console.error(`No response returned for url: $${url}`);
        throw new Error("No response returned");
      }
    } catch (e) {
      const errorString = `Error navigating to url: $${url}. $${e}`;
      console.error(errorString);
      throw e;
    }
  });

  // Reset page
  await resetPage(page);
};

export const handler = async (event, context) => {
  return await loadBlueprints();
};
