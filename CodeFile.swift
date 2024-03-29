name: "Increment build number"

# Controls when the workflow will run
on:
  # Triggers the workflow on any pull request merge on any branch
  pull_request:
    branches:
      - '**'
    types: [closed]

  # Allow us to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    if: github.event.pull_request.merged == true
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Get Branch name
        run: echo '::set-output name=BRANCH::$(git rev-parse --abbrev-ref HEAD | cut -c1-7)'
        id: get_branch_name

      - name: Read ConfigVersion from file
        id: step_a
        run: cat ConfigVersion.xcconfig >> $GITHUB_ENV 

      - name: Write new version on ConfigVersion.xcconfig
        id: step_b
        run: |
          echo "Version ${{ env.MARKETING_VERSION }} - ($((${{ env.CURRENT_PROJECT_VERSION }}+1)))"
          echo "MARKETING_VERSION=${{ env.MARKETING_VERSION }}" > ConfigVersion.xcconfig
          echo "CURRENT_PROJECT_VERSION=$((${{ env.CURRENT_PROJECT_VERSION }}+1))" >> ConfigVersion.xcconfig

          git config --global user.name 'maurodevitopix4d'
          git config --global user.email 'mauro.devito@pix4d.com'          
          git add ConfigVersion.xcconfig
          git commit -am "${{ steps.get_branch_name.outputs.BRANCH }} Ver. ${{ env.MARKETING_VERSION }} - ($((${{ env.CURRENT_PROJECT_VERSION }}+1)))"
          git push
# comment		  
****
AR-1001 new line added on this branch