import { Injectable, ConflictException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<Omit<User, 'password'>> {
    // Check if email already exists
    const existingUser = await this.userRepository.findOne({
      where: { email: createUserDto.email },
    });

    if (existingUser) {
      throw new ConflictException('Email already exists');
    }

    // Hash password
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(createUserDto.password, saltRounds);
   // 2^10 = 1,024 times.
   // Security: Strong enough for most applications
   // Performance: Reasonable speed (takes ~100-200ms)
    // Create user
    const user = this.userRepository.create({
      ...createUserDto,
      password: hashedPassword,
      isActive: true,
      isSuspended: false,
    });

    const savedUser = await this.userRepository.save(user);

    // Return user without password
    const { password, ...userWithoutPassword } = savedUser;
    return userWithoutPassword;
  }
  async findAllUsers(): Promise<User[]> {
    return this.userRepository.find();
  }
}
