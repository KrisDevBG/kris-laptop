<script lang="ts">
  import { createEventDispatcher, onDestroy, onMount } from "svelte";
  import logo from "@assets/logo.png";
  import { openedApps } from "@store/desktop";
  import { flip } from "svelte/animate";
  import { fade, scale } from "svelte/transition";
  import { cubicIn, cubicInOut, cubicOut } from "svelte/easing";
  import { each } from "svelte/internal";

  interface ITime {
    times: string;
    date: string;
  }
  let time: ITime = {
    times: "--:-- AM",
    date: "-/-/----",
  };
  let showRightside = false;
  let showWifiMenu = false;
  let playerGne = 0;
  let wifiNetworks = [["Tashaci", 112233]];
  let currentNetwork = "Bulgar State";
  let dispatch = createEventDispatcher();
  let toggleRightside = () => {
    showRightside = !showRightside;
    dispatch("toggleRightside", showRightside);
  };

  // let toggleWifiMenu = () => {
  //   showWifiMenu = !showWifiMenu;
  //   dispatch("toggleWifiMenu", showWifiMenu);
  // }

  function toggleWifiMenu() {
    if (showWifiMenu) {
      document.getElementById("wifi-menu").style.right = "-30vh";
      showWifiMenu = false;
    } else {
      document.getElementById("wifi-menu").style.right = "0";
      showWifiMenu = true;
    }
  }

  let shownNetwork = false;
  function connectToWifi(network) {
    if (!shownNetwork) {
      shownNetwork = true;
      let element = document.getElementById(`option-${network[0]}`);
      var input = document.createElement("input");
      element.style.backgroundColor = "rgba(75, 77, 91, 0.508)";
      element.style.height = "15vh";
      input.type = "password";
      input.name = "wifipass";
      input.style.height = "3vh";
      input.style.marginTop = "2vh";
      input.style.fontSize = "15px";
      input.style.outline = "none";
      input.style.border = "none";
      input.style.outline = "none";
      input.setAttribute("id", "network-shit")
      input.style.backgroundColor = "rgba(75, 77, 91, 0.508)";
      element.appendChild(input);
      document.getElementById("network-shit").focus();
    } else {
      shownNetwork = false;
      let element = document.getElementById(`option-${network[0]}`);
      element.style.backgroundColor = "";
      element.removeChild(document.getElementById(`network-shit`))
      element.style.height = "auto";
    }
  }

  let showsetting = false;
  let showingSetting = () => {
    showsetting = !showsetting;
    dispatch("showingSetting", showsetting);
  };

  function SetTime(data: any) {
    if (data.minute <= 9) {
      data.minute = "0" + data.minute;
    }

    const date = new Date();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    const year = date.getFullYear();
    const dateString = month + "/" + day + "/" + year;
    let stringData = data.hour + ":" + data.minute;
    time = {
      times: stringData,
      date: dateString,
    };
  }

  function Event(event: any) {
    if (event.data.action === "time") {
      SetTime(event.data.time);
    }
    if (event.data.action === "playercrypto") {
      playerGne = event.data.crypto;
    }
  }

  function IClick(appname: string) {
    dispatch("IClick", appname);
  }

  onMount(() => {
    window.addEventListener("message", Event);
  });

  onDestroy(() => {
    window.removeEventListener("message", Event);
  });
</script>

<div class = "wifi-menu" id = "wifi-menu">
  <div style="text-align:center; margin-top:2vh;"><b>Current Network</b></div>
  <button class = "wifi-option"><i class="fa-solid fa-wifi"></i> {currentNetwork}</button>
  <div style="text-align:center; margin-top:2vh;"><b>Available Wi-Fi Networks</b></div>
  <div class = "networks" id = "networks">
    {#if wifiNetworks.length > 0}
    {#each wifiNetworks as tempNetwork}
    <div class = "wifi-option" id = "option-{tempNetwork[0]}" on:click={() => connectToWifi(tempNetwork)}><i class="fa-solid fa-wifi"></i> {tempNetwork[0]}</div>
    {/each}
    {:else}
    <div style = "text-align: center; margin-top: 2vh;">No networks available</div>
    {/if}
  </div>
</div>

<div class="winmanager">
  <div class="left-icons">
    <div class="start-icon">
      <div class="icon-start">
        <img class="start" src={logo} alt="icon" />
      </div>
      <div class="opened-apps" style="margin-left: 5px;">
        {#each $openedApps as openApp (openApp.name)}
          <div
            on:click={() => IClick(openApp.name)}
            animate:flip={{ easing: cubicOut, duration: 200 }}
            class="open-icon"
            style="background-color: {openApp.background};"
            in:fade={{ easing: cubicInOut }}
            out:scale={{ easing: cubicIn, duration: 250, opacity: 2 }}
          >
            {#if openApp.useimage}
              <img
                class="icon"
                style="width: 70%;"
                src={`./images/apps/${openApp.name}.png`}
                alt={openApp.name}
              />
            {:else if openApp.icon.startsWith("fa-")}
              <i
                class={openApp.icon}
                style="font-size: 18px; color: {openApp.color};"
              />
            {:else}
              <ion-icon
                name={openApp.icon}
                style="font-size: 25px; color: {openApp.color};"
              />
            {/if}
          </div>
        {/each}
      </div>
    </div>
  </div>
  <div class="right-icons">
    {playerGne}<i class="fa-solid fa-wallet"></i>
    <i class="fa-solid fa-user" />
    <i class="fas fa-solid fa-wifi" style="cursor: pointer;" on:click={toggleWifiMenu}/>
    <div class="times">
      <span id="time">{time.times ? time.times : "..."}</span>
      <span id="date">{time.date ? time.date : "..."}</span>
    </div>
    <i
      class="fa-regular fa-message"
      style="cursor: pointer;"
      on:click={toggleRightside}
    />
  </div>
</div>

<style>
  .wifi-option {
    margin-top: 2vh;
    width: 80%;
    margin-left: 10%;
    border: none;
    outline: none;
    height: auto;
    border-radius: 10px;
    font-size: 20px;
    text-align: center;
    cursor: pointer;
    background-color: transparent;
  }
  .wifi-menu {
    position: absolute;
    width: 30vh;
    height: 40vh;
    background-color: rgba(75, 77, 91, 0.508);
    backdrop-filter: blur(10px);
    border-radius: 4px;
    margin-bottom: 10px;
    box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1);
    font-family: "Noto Sans", sans-serif;
    right: 0;
    bottom: 4vh;
    transition: all 0.5s ease-in-out;
  }
  .open-icon {
    width: 35px;
    height: 35px;
    border-radius: 3px;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .opened-apps {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 0px;
    height: 100%;
    gap: 5px;
  }
  .times {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    font-size: 12px;
    font-family: "Segoe UI", sans-serif;
    margin: 0 15px;
  }
  .right-icons {
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    padding: 15px;
    right: 0;
  }

  .right-icons i {
    font-size: 15px;
    margin: 0 10px;
  }
  .icon-start {
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 3px;
    width: 100%;
    height: 100%;
    background-color: rgba(255, 255, 255, 0.123);
  }

  .start {
    height: 40px;
  }

  .winmanager {
    padding: 0 10px;
    width: 100%;
    height: 40px;
    position: absolute;
    bottom: 0;
    background: #1a1c25b9;
    backdrop-filter: blur(10px);
    display: flex;
    bottom: 0;
    overflow-y: hidden;
    align-items: center;
    z-index: 98;
  }

  .left-icons {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .left-icons img {
    display: flex;
    justify-content: center;
  }

  .start-icon {
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
