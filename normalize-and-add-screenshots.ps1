$ErrorActionPreference = 'Stop'
$root = 'd:\App\editremote.onlinehelp.io'

function Set-MainBlock([string]$fileName, [string]$mainBlock) {
    $path = Join-Path $root $fileName
    $text = Get-Content -Path $path -Raw

    $pattern = '(?s)<main id="main" class="main">.*</main><!-- End #main -->'
    if ([regex]::IsMatch($text, $pattern)) {
        $text = [regex]::Replace($text, $pattern, $mainBlock)
    } else {
        $footerStart = '<!-- ======= Footer ======= -->'
        if ($text.Contains($footerStart)) {
            $text = $text.Replace($footerStart, "$mainBlock`r`n`r`n  $footerStart")
        } else {
            $text += "`r`n$mainBlock`r`n"
        }
    }

    Set-Content -Path $path -Value $text -Encoding UTF8
}

$indexMain = @"
  <main id="main" class="main">
    <div class="pagetitle">
      <h1>Guida Utente EditRemote</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item active">Percorso rapido</li>
        </ol>
      </nav>
    </div>

    <section class="section">
      <div class="row">
        <div class="col-lg-7">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">Flusso consigliato</h5>
              <ol>
                <li>Imposta la modalita: Locale, Offline o Seriale.</li>
                <li>Importa i dati dalla cassa.</li>
                <li>Esegui la programmazione necessaria.</li>
                <li>Salva e verifica il risultato operativo.</li>
                <li>Esporta XML come backup.</li>
              </ol>
            </div>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">Schermata principale</h5>
              <img src="assets/img/editremote/main.jpeg" class="img-fluid rounded border" alt="Main EditRemote">
            </div>
          </div>
        </div>
      </div>
    </section>
  </main><!-- End #main -->
"@

$panoramicaMain = @"
  <main id="main" class="main">
    <div class="pagetitle">
      <h1>Panoramica app</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item">Panoramica</li>
          <li class="breadcrumb-item active">Panoramica app</li>
        </ol>
      </nav>
    </div>

    <section class="section">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">Cosa vedi in home</h5>
          <ul>
            <li>Area connessione e stato dispositivo.</li>
            <li>Matricola e modello rilevato.</li>
            <li>Lista Configurazioni per aprire le programmazioni.</li>
          </ul>
          <img src="assets/img/editremote/main.jpeg" class="img-fluid rounded border" alt="Home EditRemote">
        </div>
      </div>
    </section>
  </main><!-- End #main -->
"@

$ivaMain = @"
  <main id="main" class="main">
    <div class="pagetitle">
      <h1>Programmazione IVA</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item">Impostazioni</li>
          <li class="breadcrumb-item active">Programmazione IVA</li>
        </ol>
      </nav>
    </div>

    <section class="section">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">Procedura</h5>
          <ol>
            <li>Apri IVA dalla lista Configurazioni.</li>
            <li>Importa i valori correnti.</li>
            <li>Modifica aliquote e conferma.</li>
            <li>Salva e verifica in cassa.</li>
          </ol>
          <img src="assets/img/editremote/iva.jpeg" class="img-fluid rounded border" alt="Programmazione IVA">
        </div>
      </div>
    </section>
  </main><!-- End #main -->
"@

$repartiMain = @"
  <main id="main" class="main">
    <div class="pagetitle">
      <h1>Programmazione reparti</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item">Impostazioni</li>
          <li class="breadcrumb-item active">Programmazione reparti</li>
        </ol>
      </nav>
    </div>

    <section class="section">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">Procedura</h5>
          <ol>
            <li>Apri Reparti e importa i dati.</li>
            <li>Aggiorna descrizioni, prezzi e opzioni richieste.</li>
            <li>Salva la programmazione.</li>
          </ol>
          <div class="alert alert-warning" role="alert">
            Le modifiche reparti vengono sincronizzate con la cassa.
          </div>
          <img src="assets/img/editremote/reparti.jpeg" class="img-fluid rounded border" alt="Programmazione reparti">
        </div>
      </div>
    </section>
  </main><!-- End #main -->
"@

$clientiMain = @"
  <main id="main" class="main">
    <div class="pagetitle">
      <h1>Programmazione clienti</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item">Impostazioni</li>
          <li class="breadcrumb-item active">Programmazione clienti</li>
        </ol>
      </nav>
    </div>

    <section class="section">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">Procedura</h5>
          <ol>
            <li>Apri Clienti e importa.</li>
            <li>Compila anagrafica, indirizzo e dati fiscali necessari.</li>
            <li>Salva e verifica le anagrafiche in cassa.</li>
          </ol>
          <img src="assets/img/editremote/clienti.jpeg" class="img-fluid rounded border" alt="Programmazione clienti">
        </div>
      </div>
    </section>
  </main><!-- End #main -->
"@

$abbonamentoMain = @"
  <main id="main" class="main">
    <div class="pagetitle">
      <h1>Abbonamento app</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.html">Home</a></li>
          <li class="breadcrumb-item">Impostazioni</li>
          <li class="breadcrumb-item active">Abbonamento app</li>
        </ol>
      </nav>
    </div>

    <section class="section">
      <div class="card">
        <div class="card-body">
          <h5 class="card-title">Gestione abbonamento</h5>
          <p>Da questa sezione puoi verificare stato, rinnovo e validita dei servizi collegati all'app.</p>
          <img src="assets/img/editremote/abbonamento.jpeg" class="img-fluid rounded border" alt="Abbonamento app">
        </div>
      </div>
    </section>
  </main><!-- End #main -->
"@

$faqMain = @"
  <main id="main" class="main">
    <div class="pagetitle"><h1>FAQ EditRemote</h1></div>
    <section class="section"><div class="card"><div class="card-body">
      <h5 class="card-title">Domande frequenti</h5>
      <p><strong>La cassa non risponde:</strong> verifica tipo connessione e IP locale.</p>
      <p><strong>UI compressa su Android:</strong> chiudi e riapri la schermata, poi controlla orientamento portrait.</p>
      <p><strong>Import/Export XML non disponibile:</strong> controlla permessi file e stato abbonamento.</p>
    </div></div></section>
  </main><!-- End #main -->
"@

$contactMain = @"
  <main id="main" class="main">
    <div class="pagetitle"><h1>Supporto EditRemote</h1></div>
    <section class="section"><div class="card"><div class="card-body">
      <h5 class="card-title">Dati utili per assistenza</h5>
      <ol>
        <li>Modello RT e revisione firmware.</li>
        <li>Sistema operativo del dispositivo.</li>
        <li>Sequenza passi per riprodurre il problema.</li>
        <li>Screenshot o log allegati.</li>
      </ol>
    </div></div></section>
  </main><!-- End #main -->
"@

$blankMain = @"
  <main id="main" class="main">
    <div class="pagetitle"><h1>Pagina in aggiornamento</h1></div>
    <section class="section"><div class="card"><div class="card-body">
      <p>Contenuto in preparazione per una prossima revisione della guida.</p>
    </div></div></section>
  </main><!-- End #main -->
"@

$error404Main = @"
  <main id="main" class="main">
    <div class="pagetitle"><h1>Pagina non trovata</h1></div>
    <section class="section"><div class="card"><div class="card-body">
      <p>La pagina richiesta non e disponibile. Torna alla <a href="index.html">home della guida</a>.</p>
    </div></div></section>
  </main><!-- End #main -->
"@

Set-MainBlock 'index.html' $indexMain
Set-MainBlock 'panoramica_app.html' $panoramicaMain
Set-MainBlock 'impostazioni_prog_iva.html' $ivaMain
Set-MainBlock 'impostazioni_prog_reparti.html' $repartiMain
Set-MainBlock 'impostazioni_clienti.html' $clientiMain
Set-MainBlock 'impostazioni_abbonamento.html' $abbonamentoMain
Set-MainBlock 'pages-faq.html' $faqMain
Set-MainBlock 'pages-contact.html' $contactMain
Set-MainBlock 'pages-blank.html' $blankMain
Set-MainBlock 'pages-error-404.html' $error404Main

'Normalized and screenshot sections applied.'