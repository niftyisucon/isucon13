module.exports = async ({ github, context, core }) => {
  const fs = require('fs');
  const alp_result = fs.readFileSync("scripts/alp_result.txt")
  const serverName = process.env.TARGET_SERVER || 'Unknown Server'; // Default to 'Unknown Server' if TARGET_SERVER is not set
  const result = await github.rest.issues.create({
    owner: context.repo.owner,
    repo: context.repo.repo,
    title: `Benchmark result on ${serverName}`, // Updated title to include server name
    body: alp_result.toString()
  })

  const readline = require('readline');
  const rs = fs.ReadStream('scripts/pt_result.txt');
  const rl = readline.createInterface({ 'input': rs, 'output': {} });
  let lines = '';
  rl.on('line', (lineString) => {
    if (lineString.match(/Query 6/)) {
      rl.close();
      rl.removeAllListeners();
      return;
    }
    lines += lineString + '\n';
  });

  rl.on('close', () => {
    github.rest.issues.createComment({
      owner: context.repo.owner,
      repo: context.repo.repo,
      issue_number: result.data.number,
      body: "```\n" + lines + "```\n"
    })
  })

  rl.resume()
}
