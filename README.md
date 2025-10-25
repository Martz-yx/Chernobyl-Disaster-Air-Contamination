# The Chernobyl Disaster Air Contamination in neighbouring countries
This project investigates the critical role of immediate and short-term weather conditions following the April 1986 Chernobyl disaster. We focus specifically on how dynamic atmospheric factors—primarily precipitation (radioactive rain)—dictated the initial and highly uneven distribution its subsequent fallout on nearby and regional cities.

import { DatabricksDashboard } from "@databricks/aibi-client";
  
const dashboard = new DatabricksDashboard({
  instanceUrl: "https://dbc-e87634ff-5cdb.cloud.databricks.com",
  workspaceId: "3820980837529175",
  dashboardId: "01f0ab89712819ebb209d912c3d8f727",
  token: "<<CREATED_BY_YOUR_SERVER>>", // This token should be minted by your server
  container: document.getElementById("dashboard-container"),
});

dashboard.initialize();
