import * as vscode from "vscode";
import * as path from "path";
import { Story } from "inkjs/engine/Story";
import { Compiler } from "inkjs/compiler/Compiler";

export class InkPreviewProvider {
  private panel: vscode.WebviewPanel | undefined;
  private currentDocument: vscode.TextDocument | undefined;
  private fileWatcher: vscode.FileSystemWatcher | undefined;
  private currentStory: Story | undefined;

  constructor(private context: vscode.ExtensionContext) {}

  public async showPreview(document?: vscode.TextDocument) {
    // Get the active document if not provided
    if (!document) {
      const editor = vscode.window.activeTextEditor;
      if (!editor || editor.document.languageId !== "ink") {
        vscode.window.showErrorMessage("Please open an .ink file to preview");
        return;
      }
      document = editor.document;
    }

    this.currentDocument = document;

    // Create or show the webview panel
    if (this.panel) {
      this.panel.reveal(vscode.ViewColumn.Beside);
    } else {
      this.panel = vscode.window.createWebviewPanel(
        "inkPreview",
        `Preview: ${path.basename(document.fileName)}`,
        vscode.ViewColumn.Beside,
        {
          enableScripts: true,
          retainContextWhenHidden: true,
          localResourceRoots: [this.context.extensionUri],
        }
      );

      this.panel.onDidDispose(() => {
        this.panel = undefined;
        this.currentStory = undefined;
        this.disposeFileWatcher();
      });

      // Handle messages from the webview
      this.panel.webview.onDidReceiveMessage(
        (message) => {
          this.handleWebviewMessage(message);
        },
        undefined,
        this.context.subscriptions
      );
    }

    // Set up file watcher for live reload
    this.setupFileWatcher(document.uri);

    // Update the preview content
    await this.updatePreview(document);
  }

  private async handleWebviewMessage(message: any) {
    switch (message.type) {
      case "choiceSelected":
        if (this.currentStory && message.index !== undefined) {
          try {
            // Make the choice
            this.currentStory.ChooseChoiceIndex(message.index);

            // Continue the story and get new content
            let newContent = "";
            while (this.currentStory.canContinue) {
              newContent += this.currentStory.Continue();
            }

            // Get new choices
            const choices = this.currentStory.currentChoices.map(
              (choice) => choice.text
            );

            // Send update to webview
            this.panel?.webview.postMessage({
              type: "updateStory",
              content: newContent,
              choices: choices,
            });
          } catch (error) {
            vscode.window.showErrorMessage(
              `Error processing choice: ${error instanceof Error ? error.message : String(error)}`
            );
          }
        }
        break;

      case "restart":
        if (this.currentDocument) {
          await this.updatePreview(this.currentDocument);
        }
        break;
    }
  }

  private setupFileWatcher(uri: vscode.Uri) {
    // Dispose existing watcher
    this.disposeFileWatcher();

    // Create new watcher for the current file
    const pattern = new vscode.RelativePattern(
      path.dirname(uri.fsPath),
      path.basename(uri.fsPath)
    );
    this.fileWatcher = vscode.workspace.createFileSystemWatcher(pattern);

    this.fileWatcher.onDidChange(async () => {
      if (this.currentDocument) {
        await this.updatePreview(this.currentDocument);
      }
    });
  }

  private disposeFileWatcher() {
    if (this.fileWatcher) {
      this.fileWatcher.dispose();
      this.fileWatcher = undefined;
    }
  }

  private async updatePreview(document: vscode.TextDocument) {
    if (!this.panel) {
      return;
    }

    try {
      // Get the ink source code
      const inkSource = document.getText();

      // Compile the ink source to JSON
      const compiler = new Compiler(inkSource);
      const storyJson = compiler.Compile();

      if (storyJson) {
        // Create a story from the compiled JSON
        this.currentStory = new Story(storyJson);

        // Update the webview with the story
        this.panel.webview.html = this.getWebviewContent(this.currentStory);
      } else {
        throw new Error("Failed to compile ink source");
      }
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      this.panel.webview.html = this.getErrorContent(errorMessage);
      vscode.window.showErrorMessage(`Ink compilation error: ${errorMessage}`);
    }
  }

  private getWebviewContent(story: Story): string {
    // Get initial story content
    let initialContent = "";
    const choices: string[] = [];

    try {
      while (story.canContinue) {
        initialContent += story.Continue();
      }

      if (story.currentChoices.length > 0) {
        story.currentChoices.forEach((choice) => {
          choices.push(choice.text);
        });
      }
    } catch (error) {
      console.error("Error reading story:", error);
    }

    const storyJson = JSON.stringify(story.ToJson());
    const choicesHtml = choices
      .map(
        (choice, index) =>
          `<button class="choice" data-index="${index}">${this.escapeHtml(choice)}</button>`
      )
      .join("");

    return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ink Preview</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
            line-height: 1.6;
            color: var(--vscode-editor-foreground);
            background-color: var(--vscode-editor-background);
        }
        
        #story-content {
            margin-bottom: 20px;
            white-space: pre-wrap;
        }
        
        #choices {
            margin-top: 20px;
        }
        
        .choice {
            display: block;
            width: 100%;
            padding: 12px 16px;
            margin-bottom: 10px;
            text-align: left;
            background-color: var(--vscode-button-secondaryBackground);
            color: var(--vscode-button-secondaryForeground);
            border: 1px solid var(--vscode-button-border);
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        
        .choice:hover {
            background-color: var(--vscode-button-secondaryHoverBackground);
        }
        
        .choice:active {
            background-color: var(--vscode-button-background);
            color: var(--vscode-button-foreground);
        }
        
        .error {
            color: var(--vscode-errorForeground);
            background-color: var(--vscode-inputValidation-errorBackground);
            border: 1px solid var(--vscode-inputValidation-errorBorder);
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .restart-btn {
            padding: 8px 16px;
            background-color: var(--vscode-button-background);
            color: var(--vscode-button-foreground);
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            margin-top: 20px;
        }
        
        .restart-btn:hover {
            background-color: var(--vscode-button-hoverBackground);
        }
        
        .end-message {
            font-style: italic;
            color: var(--vscode-descriptionForeground);
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div id="story-content">${this.escapeHtml(initialContent)}</div>
    <div id="choices">${choicesHtml}</div>
    ${
      choices.length === 0 && !story.canContinue
        ? '<div class="end-message">THE END</div><button class="restart-btn" onclick="restart()">Restart Story</button>'
        : ""
    }
    
    <script>
        const vscode = acquireVsCodeApi();
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        document.querySelectorAll('.choice').forEach(button => {
            button.addEventListener('click', function() {
                const choiceIndex = parseInt(this.getAttribute('data-index'));
                vscode.postMessage({
                    type: 'choiceSelected',
                    index: choiceIndex
                });
            });
        });
        
        window.restart = function() {
            vscode.postMessage({
                type: 'restart'
            });
        };
        
        // Listen for messages from the extension
        window.addEventListener('message', event => {
            const message = event.data;
            
            switch (message.type) {
                case 'updateStory':
                    // Use textContent to safely display story content
                    document.getElementById('story-content').textContent = message.content;
                    
                    const choicesDiv = document.getElementById('choices');
                    if (message.choices && message.choices.length > 0) {
                        choicesDiv.innerHTML = message.choices.map((choice, index) => 
                            \`<button class="choice" data-index="\${index}">\${escapeHtml(choice)}</button>\`
                        ).join('');
                        
                        // Re-attach event listeners
                        document.querySelectorAll('.choice').forEach(button => {
                            button.addEventListener('click', function() {
                                const choiceIndex = parseInt(this.getAttribute('data-index'));
                                vscode.postMessage({
                                    type: 'choiceSelected',
                                    index: choiceIndex
                                });
                            });
                        });
                    } else {
                        choicesDiv.innerHTML = '<div class="end-message">THE END</div><button class="restart-btn" onclick="restart()">Restart Story</button>';
                    }
                    break;
            }
        });
    </script>
</body>
</html>`;
  }

  private getErrorContent(errorMessage: string): string {
    return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ink Preview - Error</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
            line-height: 1.6;
            color: var(--vscode-editor-foreground);
            background-color: var(--vscode-editor-background);
        }
        
        .error {
            color: var(--vscode-errorForeground);
            background-color: var(--vscode-inputValidation-errorBackground);
            border: 1px solid var(--vscode-inputValidation-errorBorder);
            padding: 12px;
            border-radius: 4px;
            white-space: pre-wrap;
        }
        
        h2 {
            color: var(--vscode-errorForeground);
        }
    </style>
</head>
<body>
    <h2>Compilation Error</h2>
    <div class="error">${this.escapeHtml(errorMessage)}</div>
</body>
</html>`;
  }

  private escapeHtml(text: string): string {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  public dispose() {
    this.disposeFileWatcher();
    if (this.panel) {
      this.panel.dispose();
    }
  }
}
