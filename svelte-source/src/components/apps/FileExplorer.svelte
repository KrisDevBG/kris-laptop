<script lang="ts">
    import Apps from "@components/shared/Apps.svelte";
    import { fetchNui } from "@utils/eventHandler";
    import Fa from 'svelte-fa'
    import { faUser } from '@fortawesome/free-solid-svg-icons'
    let topData = {
      title: "File Explorer",
      background: "#1c1b22",
      blur: true,
      blurstrength: 15,
      color: "#1b1b1b",
    };

    function TogglePassword() {
        let element = document.getElementById("password");
        if (element.type == "password") {
            element.type = "text";
            document.getElementById("eye-pass").classList.remove("fa-eye");
            document.getElementById("eye-pass").classList.add("fa-eye-slash");
        } else {
            element.type = "password";
            document.getElementById("eye-pass").classList.remove("fa-eye-slash");
            document.getElementById("eye-pass").classList.add("fa-eye");
        }
    }

    let imageSourceToPreview = "";
    function OpenImage(image) {
      imageSourceToPreview = "./src/assets/" + image;
      document.getElementById("file-explorer-admin").style.display = "none";
      setTimeout(() => {
        document.getElementById("file-explorer-admin").style.display = "block";
      }, 3000)

    }
</script>

<Apps topdata={topData} appname="fileexplorer">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <div class = "apps">
        <div class = "login-page">
            <div class = "admin-required">Administrator permission required. <br>Please log in using an admin account.</div>
            <div class = "login-container">
                <div class = "username">
                    <i class="fas fa-user" style = "position: absolute; margin-left: 12%; margin-top: 3%; font-size: 20px;"></i>
                    <!-- <label for="username">Username</label> -->
                    <input type="text" id="username" name="username" placeholder="Username">
                </div>
                <div class = "password">
                    <i class="fas fa-lock" style = "position: absolute; margin-left: 12%; margin-top: 3%; font-size: 20px;"></i>
                    <!-- <label for="password">Password</label> -->
                    <input type="password" id="password" name="password" placeholder="Password">
                    <i id = "eye-pass" class="fa-solid fa-eye" on:click={() => TogglePassword()} style = "position: absolute; margin-left: -7%; margin-top: 3%; font-size: 20px;"></i>
                </div>
                <input type="checkbox" id="remember" name="remember">
                <label for="remember">Remember me</label>
                <div class = "login-button" style="cursor: pointer;">SIGN IN</div>
                <div class="separator">OR</div>
                <div class = "other-options">
                    <div class = "button"style="cursor: pointer;"><i class="fa-solid fa-mobile"></i><br>Phone</div>
                    <div class = "button"style="cursor: pointer;"><i class="fa-solid fa-wifi"></i><br>Wi-Fi</div>
                    <div class = "button"style="cursor: pointer;"><i class="fa-solid fa-bag-shopping"></i><br>Item</div>
                </div>
                <div class="separator">CAN'T SIGN IN?</div>
                <p style = "width: 80%; margin-left: 10%; margin-top: 2vh; text-align: center;">Well there is a little problem. We can't help you. Maybe try with a new account?</p>
            </div>
        </div>
        <div class = "file-explorer-admin" id = "file-explorer-admin">
          <div class = "file-items">
            <div class = "file-item"><i class="fa-solid fa-folder-open" style = "font-size: 60px; padding-top: 1vh;"></i> <br><p style = "margin-top: 1vh;">Memories</p></div>
            <div class = "file-item"><i class="fa-solid fa-folder-open" style = "font-size: 60px; padding-top: 1vh;"></i> <br><p style = "margin-top: 1vh;">Sekretno</p></div>
            <div class = "file-item"><i class="fa-solid fa-folder-open" style = "font-size: 60px; padding-top: 1vh;"></i> <br><p style = "margin-top: 1vh;">Ne otvarqi</p></div>
            <div class = "file-item"><i class="fa-solid fa-folder" style = "font-size: 60px; padding-top: 1vh;"></i> <br><p style = "margin-top: 1vh;"><i class="fa-solid fa-skull"></i> | <i class="fa-solid fa-skull"></i> | <i class="fa-solid fa-skull"></i></p></div>
            <div class = "file-item"><i class="fa-solid fa-folder" style = "font-size: 60px; padding-top: 1vh;"></i> <br><p style = "margin-top: 1vh;">For Later Use</p></div>
            <div class = "file-item"><i class="fa-solid fa-file-word" style = "font-size: 60px; padding-top: 1vh;"></i> <br><p style = "margin-top: 1vh;">codes.docx</p></div>
            <div class = "file-item" on:click={() => OpenImage('qka_kaka.png')}><i class="fa-solid fa-image" style = "font-size: 60px; padding-top: 1vh;"></i> <br><p style = "margin-top: 1vh;">qka_kaka.png</p></div>
            <div class = "file-item" on:click={() => OpenImage('database.png')}><i class="fa-solid fa-image" style = "font-size: 60px; padding-top: 1vh;"></i> <br><p style = "margin-top: 1vh;">databse.png</p></div>
          </div>
        </div>
        <div class = "image-preview">
          <img src = {imageSourceToPreview} alt = "nqqma" style = "width: 100%;">
        </div>
    </div>
</Apps>

<style>
  .file-item {
    text-align: center;
    width: 15vh;
    height: 12vh;
    background-color: gray;
    border-radius: 10px;
    font-size: 20px;
    float: left;
    margin-left: 1vh;
    margin-top: 1vh;
    cursor: pointer;
    text-overflow: ellipsis;
  }
  .image-preview {
    visibility: hidden;
  }
  .file-items {
    position: absolute;
    left: 10%;
    top: 30%;
    width: 89%;
    height: 48vh;
  }
  .file-explorer-admin {
    width: 100%;
    height: 100%;
    background-image: url("../../assets/fileexp.png");
    background-size: cover;
    display: none;
  }
  .apps {
    overflow: hidden;
    height: 100%;
  }
  .login-button {
    margin-top: 2vh;
    width: 80%;
    margin-left: 10%;
    height: 5vh;
    background-color: rgba(50, 56, 77, 0.527);
    text-align: center;
    font-size: 20px;
    padding-top: 2%;
    font-variant: small-caps;
  }
  .button {
    margin-top: 2vh;
    margin-left: 2vh;
    width: 10.7vh;
    height: 7vh;
    text-align: center;
    font-size: 20px;
    float: left;
    transition: 0.2s;
  }
  .button:hover {
    transition: 0.2s;
    transform: scale(1.1);
  }
  .other-options {
    width: fit-content;
    max-width: 80%;
    margin-left: 10%;
    height: 5vh;
  }
  .admin-required {
    font-size: 20px;
    text-align: center;
  }
  .login-page {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    display: block;
  }
  .login-container {
    margin-top: 2vh;
    width: 50vh;
    height: 50vh;
    border: 1px solid gray;
  }
  input[type=text], input[type=password] {
    width: 80%;
    padding: 12px 40px; 
    margin-left: 10%;
    height: 5vh;
    background-color: rgba(50, 56, 77, 0.527);
    border: none;
    outline: none;
    font-size: 20px;
  }
  input[type=checkbox] {
    margin-left: 10%;
    margin-top: 2vh;
  }
  .username {
    position: relative;
    margin-top: 2vh;
  }
  .password {
    position: relative;
    margin-top: 2vh;
  }
  .separator {
    margin-top: 2vh;
    display: flex;
    align-items: center;
    text-align: center;
    width: 80%;
    margin-left: 10%;
  }

  .separator::before,
  .separator::after {
    content: '';
    flex: 1;
    border-bottom: 1px solid #fff;
  }

  .separator:not(:empty)::before {
    margin-right: .25em;
  }

  .separator:not(:empty)::after {
    margin-left: .25em;
  }
  * {
    font-family: "Noto Sans", sans-serif;
  }
</style>