use {
    anyhow::Result,
    clap::Args,
    log::{error, info},
    serde_json::Value,
};

#[derive(Args)]
pub struct IpCommand {}

pub fn command_ip(_: IpCommand) -> Result<()> {
    let response = minreq::get("https://qifu-api.baidubce.com/ip/local/geo/v1/district?").send()?;

    if response.status_code != 200 {
        return Err(anyhow::anyhow!(
            "Failed to fetch IP information, status code: {}",
            response.status_code
        ));
    }

    let json: Value = response.json()?;

    info!("IP Address: {}", json["ip"].as_str().unwrap_or("Unknown"));

    if let Some(data) = json["data"].as_object() {
        if let Some(isp) = data.get("isp") {
            info!("ISP: {}", isp.as_str().unwrap_or("Unknown"));
        }

        if let Some(country) = data.get("country") {
            info!("Country: {}", country.as_str().unwrap_or("Unknown"));
        }

        if let Some(prov) = data.get("prov") {
            info!("Province: {}", prov.as_str().unwrap_or("Unknown"));
        }

        if let Some(city) = data.get("city") {
            info!("City: {}", city.as_str().unwrap_or("Unknown"));
        }

        if let Some(district) = data.get("district") {
            info!("District: {}", district.as_str().unwrap_or("Unknown"));
        }
    } else {
        error!("Unexpected response format: 'data' is not an object");
    }
    Ok(())
}
