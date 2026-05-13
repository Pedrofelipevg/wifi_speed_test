# Wi-Fi Speed Test
> Aplicativo prático e rápido para medir a velocidade e qualidade da sua conexão de internet.

## Descrição do projeto
O **Wi-Fi Speed Test** é um aplicativo mobile desenvolvido para realizar testes precisos de velocidade de internet e Wi-Fi. Ele fornece métricas detalhadas sobre o desempenho da rede, exibindo dados cruciais como **Ping** (latência), **Download** e **Upload**. 

O aplicativo conta com uma interface moderna e intuitiva, que inclui uma tela de termo de aceite no primeiro acesso, uma tela inicial com velocímetro interativo para testes em tempo real, exibição detalhada dos resultados após cada teste, além de um histórico local que permite ao usuário acompanhar a evolução da qualidade de sua conexão ao longo do tempo.

## Objetivo
O objetivo geral do sistema é fornecer aos usuários uma ferramenta confiável e acessível para o monitoramento da qualidade de sua conexão com a internet. O aplicativo busca resolver o problema da falta de transparência sobre as reais velocidades entregues pelos provedores de internet, permitindo que os usuários verifiquem se estão recebendo o serviço contratado de forma simples e direta no seu smartphone.

## Tecnologias utilizadas
Para a construção deste aplicativo, foram empregadas as seguintes tecnologias e pacotes:
*   **Flutter:** Framework de UI para criação de aplicações nativas compiladas a partir de um único código base.
*   **Dart:** Linguagem de programação orientada a objetos utilizada pelo Flutter.
*   **Android / Gradle / Kotlin:** Base da infraestrutura para compilação e execução da versão Android do aplicativo.
*   **provider:** Utilizado para injeção de dependência e gerenciamento de estado (ChangeNotifier).
*   **shared_preferences:** Para armazenamento de dados locais (histórico de testes e aceite dos termos).
*   **flutter_speed_test_plus:** Responsável pela medição real das velocidades de download e upload.
*   **syncfusion_flutter_gauges:** Criação do velocímetro interativo na tela principal.
*   **connectivity_plus:** Verificação do status de conexão do dispositivo (se há rede disponível).
*   **http:** Utilizado para cálculo de Ping em servidores externos.
*   **uuid** e **intl:** Geração de identificadores únicos para os resultados e formatação de datas.

## Arquitetura do projeto
O projeto foi desenvolvido adotando o padrão de arquitetura **MVVM (Model-View-ViewModel)**, o que garante uma excelente separação de responsabilidades e facilita a manutenção do código. A organização das pastas reflete essa arquitetura:

*   **models:** Contém as classes de dados e entidades do domínio do aplicativo (ex: `test_result.dart`).
*   **viewmodels:** Concentra a lógica de negócio e o estado das telas, utilizando `ChangeNotifier` para atualizar a interface. Funciona como um intermediário entre a View e os Services (ex: `speed_test_viewmodel.dart`).
*   **services:** Encapsula o acesso a recursos externos e regras de infraestrutura, como chamadas de rede e armazenamento local (ex: `speed_test_service.dart`, `storage_service.dart`).
*   **views (screens):** Armazena os componentes visuais, telas e widgets do aplicativo. Elas apenas observam o ViewModel e reagem às mudanças de estado, sem conter lógica de negócio complexa.

## Funcionamento do aplicativo
O fluxo de uso do aplicativo é projetado para ser intuitivo:
1.  **Abertura e Termo de Aceitação:** Ao abrir o app pela primeira vez, o usuário é apresentado a uma tela de Termos de Uso. É necessário aceitar os termos para prosseguir. Essa decisão é salva localmente.
2.  **Tela Principal:** A tela inicial exibe um velocímetro central (Gauge). O aplicativo também verifica constantemente se há conexão com a internet.
3.  **Botão de Iniciar Teste:** O usuário clica em "START TEST" para iniciar a medição. A UI reage imediatamente exibindo a progressão (barra de progresso) e o status do teste ("Testing Download...", "Testing Upload...").
4.  **Exibição dos Resultados:** Durante o teste, o velocímetro e os valores textuais (Ping, Download, Upload) são atualizados em tempo real. Ao concluir, uma tela de resultados (`ResultScreen`) é apresentada com os dados finais.
5.  **Histórico:** Pelo ícone no topo da tela inicial, o usuário pode acessar a tela de Histórico, onde todos os testes anteriores realizados ficam salvos e listados por data.
6.  **Configurações/Informações:** Também é possível rever os termos de uso a partir do botão de informações na AppBar.

## Gerenciamento de estado
O estado do aplicativo é controlado através do pacote **Provider** em conjunto com a classe `ChangeNotifier` do Flutter. 
*   Os **ViewModels** (`SpeedTestViewModel`, `HistoryViewModel`) encapsulam as variáveis de estado (como velocidades atuais, progresso, mensagens de erro e estado da conexão).
*   Eles notificam os ouvintes (`notifyListeners()`) sempre que uma alteração ocorre (ex: a cada atualização de progresso do teste de velocidade).
*   A interface (Views) utiliza o widget `Consumer` para escutar essas mudanças e se reconstruir automaticamente apenas quando necessário, garantindo atualizações fluidas durante o teste.

## Serviços e lógica de backend/local
O aplicativo não possui um backend remoto próprio para armazenamento, toda a lógica e salvamento de dados ocorrem **localmente** no dispositivo.
*   **Teste de Velocidade:** O serviço `SpeedTestService` é responsável por orquestrar o teste, realizando medições de Ping (via requisição HTTP) e utilizando a biblioteca `flutter_speed_test_plus` para calcular as taxas de transferência de download e upload conectando-se a servidores de teste.
*   **Armazenamento de Dados:** O serviço `StorageService` utiliza o `shared_preferences` para persistir dados estruturados em formato JSON. É através dele que o aceite dos Termos de Uso e o Histórico de Testes são salvos e recuperados de forma permanente no celular do usuário.

## Permissões utilizadas
Para que o aplicativo funcione corretamente e consiga realizar os testes de rede, as seguintes permissões foram declaradas no `AndroidManifest.xml` (Android):
*   `android.permission.INTERNET`: Essencial para que o aplicativo possa realizar as requisições web, baixar arquivos de teste e calcular a velocidade da rede.
*   `android.permission.ACCESS_NETWORK_STATE`: Necessária para que o aplicativo possa verificar se o dispositivo possui conexão de rede ativa através do pacote `connectivity_plus`, além de reagir a mudanças de estado da rede.

## Como executar o projeto
Para rodar este projeto em sua máquina local, certifique-se de ter o [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado. 

Siga o passo a passo abaixo:
1.  Clone este repositório ou baixe os arquivos fonte.
2.  Abra o terminal na raiz do projeto.
3.  Instale as dependências executando:
    ```bash
    flutter pub get
    ```
4.  Verifique os dispositivos conectados (emuladores ou smartphones reais) executando:
    ```bash
    flutter devices
    ```
5.  Para rodar o app no dispositivo padrão (ou no Emulador Android, caso esteja aberto), utilize o comando:
    ```bash
    flutter run
    ```
*Nota: O projeto tem suporte básico à Web (Chrome), porém o teste de velocidade real requer plataforma nativa. No Chrome, o aplicativo rodará com um "teste simulado" embutido no código para fins de depuração.*

## Como gerar APK
Para gerar um pacote de instalação Android (APK) pronto para uso em aparelhos reais, execute o seguinte comando na raiz do projeto:
```bash
flutter build apk
```
Após o término do processo (que pode levar alguns minutos), o arquivo APK gerado estará disponível no diretório:
`build/app/outputs/flutter-apk/app-release.apk`

## Uso do Antigravity com Inteligência Artificial
Neste projeto, o **Antigravity com IA** foi utilizado como uma poderosa ferramenta de apoio durante o fluxo de desenvolvimento. O seu uso auxiliou diretamente em diversas etapas, incluindo:
*   Criação da estrutura inicial do projeto e definição de pastas.
*   Organização da arquitetura MVVM, separando adequadamente os ViewModels e Views.
*   Criação e ajuste de telas com Flutter, refinando o design e a experiência do usuário.
*   Implementação de funcionalidades complexas, como a integração do teste de velocidade.
*   Correção de erros de build e análise de mensagens de erro durante a compilação do Android.
*   Melhoria contínua do código-fonte e boas práticas.
*   Documentação detalhada do projeto, incluindo este arquivo README.
*   Apoio constante na produtividade do desenvolvedor.

**Importante:** A IA funcionou exclusivamente como uma ferramenta auxiliar e aceleradora. Todo o desenvolvimento lógico, os testes, os ajustes refinados e as validações finais foram supervisionados e acompanhados pelo desenvolvedor humano, garantindo a qualidade e segurança do aplicativo.

## Estrutura de pastas
Abaixo está a representação simplificada das principais pastas e arquivos do projeto:

```text
wifi_speed_test/
├── android/
│   ├── app/
│   ├── build.gradle
│   └── ...
├── lib/
│   ├── models/
│   │   └── test_result.dart
│   ├── services/
│   │   ├── speed_test_service.dart
│   │   └── storage_service.dart
│   ├── viewmodels/
│   │   ├── history_viewmodel.dart
│   │   └── speed_test_viewmodel.dart
│   ├── views/
│   │   ├── history_screen.dart
│   │   ├── home_screen.dart
│   │   ├── result_screen.dart
│   │   └── terms_screen.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
```

## Considerações finais
O projeto **Wi-Fi Speed Test** atende de forma eficiente à sua proposta de medir a conexão do usuário e fornecer um histórico confiável das medições, apresentando uma base de código sólida, bem arquitetada e facilmente escalável.

**Possíveis melhorias futuras:**
*   Melhorar a precisão e estabilidade do teste conectando-se a múltiplos nós de servidores simultâneos.
*   Adicionar autenticação de usuário para contas personalizadas.
*   Salvar o histórico em nuvem (ex: Firebase ou Supabase) para que os dados não sejam perdidos ao desinstalar o app.
*   Gerar relatórios estatísticos (gráficos em PDF) das qualidades da rede por períodos longos.
*   Melhorar e diversificar o design da interface, adicionando suporte a temas claro/escuro nativos e customizados.
*   Publicar o aplicativo oficialmente na Google Play Store.
