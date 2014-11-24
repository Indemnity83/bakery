<?php namespace Indemnity83\Bakery;

use Symfony\Component\Process\Process;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class InitCommand extends Command {

	/**
	 * Configure the command options.
	 *
	 * @return void
	 */
	protected function configure()
	{
		$this->setName('init')
                  ->setDescription('Create a stub Bakery.yaml file');
	}

	/**
	 * Execute the command.
	 *
	 * @param  \Symfony\Component\Console\Input\InputInterface  $input
	 * @param  \Symfony\Component\Console\Output\OutputInterface  $output
	 * @return void
	 */
	public function execute(InputInterface $input, OutputInterface $output)
	{
		if (is_dir(bakery_path()))
		{
			throw new \InvalidArgumentException("Bakery has already been initialized.");
		}

		$output->writeln('<comment>Creating Bakery.yaml file...</comment> <info>✔</info>');

		mkdir(bakery_path());

		copy(__DIR__.'/stubs/Bakery.yaml', bakery_path().'/Bakery.yaml');
		copy(__DIR__.'/stubs/after.sh', bakery_path().'/after.sh');
		copy(__DIR__.'/stubs/aliases', bakery_path().'/aliases');

		$output->writeln('<comment>Bakery.yaml file created at:</comment> '.bakery_path().'/Bakery.yaml');
	}

}
