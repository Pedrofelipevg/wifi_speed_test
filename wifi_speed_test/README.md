# Wi-Fi Speed Test - Monitor de Velocidade de Internet

Este projeto foi desenvolvido como parte da disciplina de **Programação Mobile II**. É um aplicativo funcional, organizado e pronto para auditoria de rede, utilizando as melhores práticas de desenvolvimento Flutter.

## Descrição
O **Wi-Fi Speed Test** é um app de monitoramento de rede que permite aos usuários medir com precisão a qualidade de sua conexão. Ele fornece métricas de **Ping**, **Download** e **Upload** em tempo real, com uma interface visual atraente e intuitiva.

## Público-alvo
O aplicativo é destinado a usuários que precisam auditar sua conexão de internet, verificar se estão recebendo a velocidade contratada ou simplesmente monitorar o desempenho da rede em diferentes ambientes.

## Arquitetura
O projeto segue a arquitetura **MVVM (Model-View-ViewModel)**, garantindo uma separação clara de responsabilidades e facilitando a manutenção e escalabilidade do código. A estrutura de pastas foi organizada da seguinte forma:

- **models/**: Contém as classes de dados (ex: `TestResult`).
- **viewmodels/**: Gerencia o estado da UI e a lógica de negócio, fazendo a ponte entre os dados e a interface.
- **views/**: Contém as telas e componentes visuais do aplicativo.
- **services/**: Encapsula a lógica de serviços externos, como a medição de velocidade real.
- **repositories/**: Responsável pela abstração do acesso aos dados no backend (Supabase), seguindo o Repository Pattern.

## Backend & Estado
- **Backend**: Integrado ao **Supabase** para autenticação de usuários (Login/Cadastro) e armazenamento persistente do histórico de testes de velocidade.
- **Gerenciamento de Estado**: Utiliza o pacote **Provider**, que permite o controle reativo da interface (como a animação do velocímetro e a atualização da lista de resultados) de forma eficiente.

## Uso de IA
Este projeto contou com o auxílio do **Antigravity AI** como ferramenta de apoio ao desenvolvimento. A IA foi fundamental em diversas etapas, incluindo:
- **Refatoração e Organização**: Sugestões para a estruturação das pastas seguindo rigorosamente o padrão MVVM.
- **Integração de Backend**: Apoio na implementação da camada de Repository para comunicação com o Supabase.
- **Otimização de UI/UX**: Auxílio na criação de interfaces modernas, utilizando componentes como o `syncfusion_flutter_gauges`.
- **Lógica de Estado**: Implementação refinada dos ViewModels para garantir uma experiência de usuário fluida e sem bugs.

A utilização da IA permitiu uma aceleração significativa no processo de codificação, garantindo que os requisitos acadêmicos fossem atendidos com um alto nível de qualidade técnica.

---
**Desenvolvido para a disciplina de Programação Mobile II**
